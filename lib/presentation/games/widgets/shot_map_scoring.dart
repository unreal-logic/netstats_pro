import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';

class _ShotMarker {
  _ShotMarker({
    required this.offset,
    required this.isMade,
    required this.type,
    required this.isHomeTeam,
  });
  final Offset offset;
  final bool isMade;
  final MatchEventType type;
  final bool isHomeTeam;
}

class ShotMapScoring extends StatefulWidget {
  const ShotMapScoring({
    required this.format,
    required this.onShotRecorded,
    required this.isHomeTeam,
    required this.events,
    this.isSuperShotActive = false,
    this.isSuperShotEnabled = false,
    this.isPowerPlayActive = false,
    this.homeTeamColor,
    this.awayTeamColor,
    this.initialHomeFocus = true,
    this.onActiveTeamChanged,
    super.key,
  });

  final GameFormat format;
  final bool isHomeTeam;
  final List<MatchEvent> events;
  final bool initialHomeFocus;
  final ValueChanged<bool>? onActiveTeamChanged;
  final bool isSuperShotActive;
  final bool isSuperShotEnabled;
  final bool isPowerPlayActive;
  final Color? homeTeamColor;
  final Color? awayTeamColor;
  final void Function({
    required MatchEventType type,
    required String position,
    required bool isHomeTeam,
    double? shotX,
    double? shotY,
  })
  onShotRecorded;

  static const double courtWidth = 152.5;
  static const double thirdHeight = 101.66;
  static const double verticalPadding = 10;
  static const double postX = courtWidth / 2;
  static const double postY = verticalPadding;

  @override
  State<ShotMapScoring> createState() => _ShotMapScoringState();
}

class _ShotMapScoringState extends State<ShotMapScoring> {
  Offset? _dragStart;
  Offset? _dragCurrent;
  String? _selectedPosition;
  String? _selectedResult;
  _DragPhase _phase = _DragPhase.idle;
  Offset? _invalidAttempt;
  Timer? _invalidAttemptTimer;
  late bool _activeRecordingHome;

  @override
  void initState() {
    super.initState();
    _activeRecordingHome = widget.initialHomeFocus;
  }

  @override
  void dispose() {
    _invalidAttemptTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(ShotMapScoring oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialHomeFocus != oldWidget.initialHomeFocus) {
      setState(() {
        _activeRecordingHome = widget.initialHomeFocus;
      });
    } else if (widget.isHomeTeam != oldWidget.isHomeTeam) {
      setState(() {
        _activeRecordingHome = widget.isHomeTeam;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.slate950,
        borderRadius: AppRadius.brLg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 56), // Drop the court down to center the hoop
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                layoutBuilder: (content, previous) => Stack(
                  children: [
                    if (previous.isNotEmpty) previous.first,
                    ?content,
                  ],
                ),
                transitionBuilder: (child, animation) {
                  final rotate = Tween(
                    begin: math.pi,
                    end: 0,
                  ).animate(animation);
                  return AnimatedBuilder(
                    animation: rotate,
                    child: child,
                    builder: (context, child) {
                      final isUnder =
                          (child! as KeyedSubtree).key !=
                          ValueKey(_activeRecordingHome);
                      var angle = rotate.value;
                      if (isUnder) angle = math.pi - angle;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: angle > math.pi / 2
                            ? const SizedBox.shrink()
                            : child,
                      );
                    },
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_activeRecordingHome),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: AspectRatio(
                      aspectRatio:
                          ShotMapScoring.courtWidth /
                          (ShotMapScoring.thirdHeight +
                              (ShotMapScoring.verticalPadding * 2)),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final size = constraints.biggest;
                                final pageMarkers = widget.events
                                    .where((e) {
                                      final isShot =
                                          e.type == MatchEventType.goal ||
                                          e.type == MatchEventType.miss ||
                                          e.type == MatchEventType.goal2pt ||
                                          e.type == MatchEventType.miss2pt ||
                                          e.type == MatchEventType.goal3pt ||
                                          e.type == MatchEventType.miss3pt;
                                      if (!isShot ||
                                          e.shotX == null ||
                                          e.shotY == null) {
                                        return false;
                                      }
                                      return _activeRecordingHome
                                          ? e.isHomeTeam
                                          : !e.isHomeTeam;
                                    })
                                    .map(
                                      (e) => _ShotMarker(
                                        offset: Offset(e.shotX!, e.shotY!),
                                        isMade:
                                            e.type == MatchEventType.goal ||
                                            e.type == MatchEventType.goal2pt ||
                                            e.type == MatchEventType.goal3pt,
                                        type: e.type,
                                        isHomeTeam: e.isHomeTeam,
                                      ),
                                    )
                                    .toList();

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTapDown: (d) {
                                    if (_isLocationValid(
                                      d.localPosition,
                                      size,
                                    )) {
                                      setState(() {
                                        _invalidAttempt = null;
                                        _dragStart = d.localPosition;
                                        _dragCurrent = d.localPosition;
                                        _phase = _DragPhase.position;
                                        _selectedPosition = null;
                                        _selectedResult = null;
                                      });
                                    } else {
                                      _showInvalidFeedback(d.localPosition);
                                    }
                                  },
                                  onPanStart: (d) => _handlePanStart(d, size),
                                  onPanUpdate: (d) => _handlePanUpdate(d, size),
                                  onPanEnd: (d) => _handlePanEnd(d, size),
                                  onPanCancel: () {
                                    setState(() {
                                      _dragStart = null;
                                      _dragCurrent = null;
                                      _phase = _DragPhase.idle;
                                      _selectedPosition = null;
                                      _selectedResult = null;
                                    });
                                  },
                                  child: CustomPaint(
                                    size: Size.infinite,
                                    painter: _CourtPainter(
                                      format: widget.format,
                                      isSuperShotActive:
                                          widget.isSuperShotActive,
                                      isSuperShotEnabled:
                                          widget.isSuperShotEnabled,
                                      isPowerPlayActive:
                                          widget.isPowerPlayActive,
                                      lineColor: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      circleColor: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      verticalPadding:
                                          ShotMapScoring.verticalPadding,
                                    ),
                                    foregroundPainter: _InteractionPainter(
                                      dragStart: _dragStart,
                                      dragCurrent: _dragCurrent,
                                      phase: _phase,
                                      selectedPosition: _selectedPosition,
                                      selectedResult: _selectedResult,
                                      homeColor:
                                          widget.homeTeamColor ?? cs.primary,
                                      awayColor:
                                          widget.awayTeamColor ?? cs.secondary,
                                      isHomeRecording: _activeRecordingHome,
                                      format: widget.format,
                                      markers: pageMarkers,
                                      invalidAttempt: _invalidAttempt,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePanStart(DragStartDetails details, Size size) {
    if (_dragStart == null) {
      if (!_isLocationValid(details.localPosition, size)) {
        _showInvalidFeedback(details.localPosition);
        return;
      }
      setState(() {
        _invalidAttempt = null;
        _dragStart = details.localPosition;
        _dragCurrent = details.localPosition;
        _phase = _DragPhase.position;
        _selectedPosition = null;
        _selectedResult = null;
      });
    }
  }

  void _showInvalidFeedback(Offset location) {
    unawaited(HapticFeedback.vibrate());
    _invalidAttemptTimer?.cancel();
    setState(() {
      _invalidAttempt = location;
    });
    _invalidAttemptTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _invalidAttempt = null;
        });
      }
    });
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    if (_dragStart == null) return;

    setState(() {
      _dragCurrent = details.localPosition;
      final delta = _dragCurrent! - _dragStart!;

      if (_phase == _DragPhase.position) {
        if (delta.dx.abs() > 20) {
          _phase = _DragPhase.result;
          final is6as = widget.format == GameFormat.sixAside;
          if (delta.dx < 0) {
            _selectedPosition = is6as ? 'L' : 'GS';
          } else {
            _selectedPosition = is6as ? 'A' : 'GA';
          }
        }
      } else if (_phase == _DragPhase.result) {
        if (delta.dy.abs() > 20) {
          _selectedResult = delta.dy < 0 ? 'made' : 'missed';
        } else {
          _selectedResult = null;
        }
      }
    });
  }

  void _handlePanEnd(DragEndDetails details, Size size) {
    if (_selectedPosition != null && _selectedResult != null) {
      final wasProcessed = _processShot(size);
      if (!wasProcessed) {
        _showInvalidFeedback(_dragStart!);
      }
    }

    setState(() {
      _dragStart = null;
      _dragCurrent = null;
      _phase = _DragPhase.idle;
      _selectedPosition = null;
      _selectedResult = null;
    });
  }

  double _calculateDistance(Offset localPosition, Size size) {
    final x = (localPosition.dx / size.width) * ShotMapScoring.courtWidth;
    const totalLogicalHeight =
        ShotMapScoring.thirdHeight + (ShotMapScoring.verticalPadding * 2);
    final y =
        ((localPosition.dy / size.height) * totalLogicalHeight) -
        ShotMapScoring.verticalPadding;

    return math.sqrt(
      math.pow(x - (ShotMapScoring.courtWidth / 2), 2) + math.pow(y, 2),
    );
  }

  bool _isLocationValid(Offset point, Size size) {
    // We allow taps anywhere in the touch box and clamp them
    // to court bounds in processing
    return true;
  }

  Offset _getClampedLogical(Offset point, Size size) {
    final x = (point.dx / size.width) * ShotMapScoring.courtWidth;
    const totalLogicalHeight =
        ShotMapScoring.thirdHeight + (ShotMapScoring.verticalPadding * 2);
    final y =
        ((point.dy / size.height) * totalLogicalHeight) -
        ShotMapScoring.verticalPadding;

    return Offset(
      x.clamp(0.0, ShotMapScoring.courtWidth),
      y.clamp(0.0, ShotMapScoring.thirdHeight),
    );
  }

  bool _processShot(Size size) {
    if (_dragStart == null ||
        _selectedPosition == null ||
        _selectedResult == null) {
      return false;
    }

    final logicalPos = _getClampedLogical(_dragStart!, size);
    final logicalX = logicalPos.dx;
    final logicalY = logicalPos.dy;

    final distance = _calculateDistance(_dragStart!, size);

    MatchEventType type;
    final isMade = _selectedResult == 'made';

    switch (widget.format) {
      case GameFormat.fiveAside:
        if (distance <= 35) {
          type = isMade ? MatchEventType.goal : MatchEventType.miss;
        } else if (distance <= 49) {
          type = isMade ? MatchEventType.goal2pt : MatchEventType.miss2pt;
        } else {
          type = isMade ? MatchEventType.goal3pt : MatchEventType.miss3pt;
        }
      case GameFormat.sevenAside:
        if (widget.isSuperShotEnabled) {
          if (distance > 30 && distance <= 49) {
            type = isMade ? MatchEventType.goal2pt : MatchEventType.miss2pt;
          } else if (distance <= 30) {
            type = isMade ? MatchEventType.goal : MatchEventType.miss;
          } else {
            return false;
          }
        } else {
          if (distance <= 49) {
            type = isMade ? MatchEventType.goal : MatchEventType.miss;
          } else {
            return false;
          }
        }
      case GameFormat.sixAside:
        if (distance <= 49) {
          type = isMade ? MatchEventType.goal : MatchEventType.miss;
        } else {
          type = isMade ? MatchEventType.goal2pt : MatchEventType.miss2pt;
        }
    }

    widget.onShotRecorded(
      type: type,
      position: _selectedPosition!,
      isHomeTeam: _activeRecordingHome,
      shotX: logicalX,
      shotY: logicalY,
    );
    return true;
  }
}

enum _DragPhase { idle, position, result }

class _CourtPainter extends CustomPainter {
  _CourtPainter({
    required this.format,
    required this.isSuperShotActive,
    required this.isSuperShotEnabled,
    required this.isPowerPlayActive,
    required this.lineColor,
    required this.circleColor,
    required this.verticalPadding,
  });

  final GameFormat format;
  final bool isSuperShotActive;
  final bool isSuperShotEnabled;
  final bool isPowerPlayActive;
  final Color lineColor;
  final Color circleColor;
  final double verticalPadding;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    final scaleX = size.width / ShotMapScoring.courtWidth;
    final scaleY =
        size.height / (ShotMapScoring.thirdHeight + (verticalPadding * 2));

    final postX = ShotMapScoring.courtWidth / 2 * scaleX;
    final postY = verticalPadding * scaleY;
    final circleRadius = 49.0 * scaleX;

    canvas
      ..drawLine(
        Offset(0, postY),
        Offset(size.width, postY),
        paint,
      )
      ..drawLine(
        Offset(0, postY),
        Offset(0, (ShotMapScoring.thirdHeight + verticalPadding) * scaleY),
        paint,
      )
      ..drawLine(
        Offset(size.width, postY),
        Offset(
          size.width,
          (ShotMapScoring.thirdHeight + verticalPadding) * scaleY,
        ),
        paint,
      )
      ..drawLine(
        Offset(0, (ShotMapScoring.thirdHeight + verticalPadding) * scaleY),
        Offset(
          size.width,
          (ShotMapScoring.thirdHeight + verticalPadding) * scaleY,
        ),
        paint,
      )
      ..drawArc(
        Rect.fromCircle(center: Offset(postX, postY), radius: circleRadius),
        0,
        math.pi,
        true,
        fillPaint,
      )
      ..drawArc(
        Rect.fromCircle(center: Offset(postX, postY), radius: circleRadius),
        0,
        math.pi,
        false,
        paint,
      )
      ..drawCircle(
        Offset(postX, postY),
        3 * scaleX,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );

    _drawText(
      canvas,
      Offset(
        size.width / 2,
        (ShotMapScoring.thirdHeight + verticalPadding) * scaleY - 15,
      ),
      'TRANSVERSE LINE',
      TextStyle(
        color: lineColor.withValues(alpha: 0.4),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );

    if (format == GameFormat.fiveAside) {
      final r1 = 35.0 * scaleX;
      canvas
        ..drawArc(
          Rect.fromCircle(center: Offset(postX, postY), radius: r1),
          0,
          math.pi,
          false,
          paint..color = Colors.white24,
        )
        ..drawRect(
          Rect.fromLTRB(
            0,
            postY + circleRadius * 0.7,
            size.width,
            (ShotMapScoring.thirdHeight + verticalPadding) * scaleY,
          ),
          Paint()
            ..shader =
                const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x1AFFF9C4),
                  ],
                ).createShader(
                  Rect.fromLTRB(
                    0,
                    postY,
                    size.width,
                    (ShotMapScoring.thirdHeight + verticalPadding) * scaleY,
                  ),
                ),
        );
    } else if (format == GameFormat.sevenAside &&
        (isSuperShotEnabled || isSuperShotActive)) {
      final rInner = 30.0 * scaleX;

      if (isSuperShotActive) {
        final path = Path()
          ..addArc(
            Rect.fromCircle(center: Offset(postX, postY), radius: circleRadius),
            0,
            math.pi,
          )
          ..arcTo(
            Rect.fromCircle(center: Offset(postX, postY), radius: rInner),
            math.pi,
            -math.pi,
            false,
          )
          ..close();
        canvas
          ..drawPath(
            path,
            Paint()
              ..color = AppColors.warning.withValues(alpha: 0.12)
              ..style = PaintingStyle.fill,
          )
          ..drawArc(
            Rect.fromCircle(center: Offset(postX, postY), radius: circleRadius),
            0,
            math.pi,
            false,
            paint
              ..color = AppColors.warning.withValues(alpha: 0.6)
              ..strokeWidth = 2.5,
          )
          ..drawArc(
            Rect.fromCircle(center: Offset(postX, postY), radius: rInner),
            0,
            math.pi,
            false,
            paint
              ..color = AppColors.warning.withValues(alpha: 0.6)
              ..strokeWidth = 2.0,
          );
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(postX, postY), radius: rInner),
          0,
          math.pi,
          false,
          paint
            ..color = Colors.white12
            ..strokeWidth = 1.0,
        );
      }
    } else if (format == GameFormat.sixAside) {
      canvas.drawRect(
        Rect.fromLTRB(
          0,
          postY + circleRadius * 0.7,
          size.width,
          (ShotMapScoring.thirdHeight + verticalPadding) * scaleY,
        ),
        Paint()
          ..shader =
              const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x1A2196F3),
                ],
              ).createShader(
                Rect.fromLTRB(
                  0,
                  postY,
                  size.width,
                  (ShotMapScoring.thirdHeight + verticalPadding) * scaleY,
                ),
              ),
      );
    }
  }

  void _drawText(Canvas canvas, Offset offset, String text, TextStyle style) {
    final span = TextSpan(style: style, text: text);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp
      ..layout()
      ..paint(canvas, offset - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InteractionPainter extends CustomPainter {
  _InteractionPainter({
    required this.dragStart,
    required this.dragCurrent,
    required this.phase,
    required this.selectedPosition,
    required this.selectedResult,
    required this.homeColor,
    required this.awayColor,
    required this.isHomeRecording,
    required this.format,
    required this.markers,
    this.invalidAttempt,
  });

  final Offset? dragStart;
  final Offset? dragCurrent;
  final _DragPhase phase;
  final String? selectedPosition;
  final String? selectedResult;
  final Color homeColor;
  final Color awayColor;
  final bool isHomeRecording;
  final GameFormat format;
  final List<_ShotMarker> markers;
  final Offset? invalidAttempt;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / ShotMapScoring.courtWidth;
    const totalLogicalHeight =
        ShotMapScoring.thirdHeight + (ShotMapScoring.verticalPadding * 2);
    final scaleY = size.height / totalLogicalHeight;

    for (final marker in markers) {
      final screenX = marker.offset.dx * scaleX;
      final screenY =
          (marker.offset.dy + ShotMapScoring.verticalPadding) * scaleY;
      final screenPos = Offset(screenX, screenY);

      final paint = Paint()
        ..color = marker.isMade ? AppColors.success : AppColors.error
        ..style = PaintingStyle.fill;

      canvas.drawCircle(screenPos, 3, paint);

      // Add a subtle outer ring in team color to indicate whose shot it was
      final teamPaint = Paint()
        ..color = (marker.isHomeTeam ? homeColor : awayColor).withValues(
          alpha: 0.5,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(screenPos, 5, teamPaint);

      if (marker.isMade) {
        canvas.drawCircle(
          screenPos,
          8,
          Paint()
            ..color = (marker.isHomeTeam ? homeColor : awayColor).withValues(
              alpha: 0.15,
            ),
        );
      }
    }

    if (invalidAttempt != null) {
      final paint = Paint()
        ..color = AppColors.error
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      const markerSize = 12.0;
      canvas
        ..drawLine(
          invalidAttempt! - const Offset(markerSize, markerSize),
          invalidAttempt! + const Offset(markerSize, markerSize),
          paint,
        )
        ..drawLine(
          invalidAttempt! - const Offset(markerSize, -markerSize),
          invalidAttempt! + const Offset(markerSize, -markerSize),
          paint,
        );
    }

    if (dragStart == null || dragCurrent == null) return;

    final recordingColor = isHomeRecording ? homeColor : awayColor;

    final pointPaint = Paint()
      ..color = recordingColor
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(dragStart!, 5, pointPaint)
      ..drawCircle(
        dragStart!,
        10,
        Paint()..color = pointPaint.color.withValues(alpha: 0.2),
      );

    if (phase == _DragPhase.position) {
      _drawPositionSelection(
        canvas,
        dragStart!,
        dragCurrent!,
        format,
        recordingColor,
      );
    } else if (phase == _DragPhase.result) {
      _drawResultSelection(
        canvas,
        dragStart!,
        dragCurrent!,
        selectedPosition!,
        selectedResult,
        recordingColor,
      );
    }
  }

  void _drawPositionSelection(
    Canvas canvas,
    Offset start,
    Offset current,
    GameFormat format,
    Color activeColor,
  ) {
    final is6as = format == GameFormat.sixAside;
    final leftPos = is6as ? 'L' : 'GS';
    final rightPos = is6as ? 'A' : 'GA';
    final dx = current.dx - start.dx;

    _drawButton(
      canvas,
      start + const Offset(-55, 0),
      leftPos,
      dx < -30,
      activeColor,
    );
    _drawButton(
      canvas,
      start + const Offset(55, 0),
      rightPos,
      dx > 30,
      activeColor,
    );

    canvas.drawLine(
      start + const Offset(-30, 0),
      start + const Offset(30, 0),
      Paint()
        ..color = Colors.white12
        ..strokeWidth = 2,
    );
  }

  void _drawResultSelection(
    Canvas canvas,
    Offset start,
    Offset current,
    String position,
    String? result,
    Color teamColor,
  ) {
    _drawButton(canvas, start, position, true, teamColor);

    final dy = current.dy - start.dy;
    _drawButton(
      canvas,
      start + const Offset(0, -75),
      '✓',
      dy < -30,
      AppColors.success,
    );
    _drawButton(
      canvas,
      start + const Offset(0, 75),
      '✗',
      dy > 30,
      AppColors.error,
    );

    canvas.drawLine(
      start + const Offset(0, -40),
      start + const Offset(0, 40),
      Paint()
        ..color = Colors.white12
        ..strokeWidth = 2,
    );
  }

  void _drawButton(
    Canvas canvas,
    Offset offset,
    String text,
    bool active,
    Color activeColor,
  ) {
    final paint = Paint()
      ..color = active ? activeColor : AppColors.slate800
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(offset, 22, paint)
      ..drawCircle(
        offset,
        22,
        Paint()
          ..color = Colors.white54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

    if (active) {
      canvas.drawCircle(
        offset,
        28,
        Paint()..color = activeColor.withValues(alpha: 0.2),
      );
    }

    _drawText(
      canvas,
      offset,
      text,
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  void _drawText(Canvas canvas, Offset offset, String text, TextStyle style) {
    final span = TextSpan(style: style, text: text);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp
      ..layout()
      ..paint(canvas, offset - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _InteractionPainter oldDelegate) => true;
}
