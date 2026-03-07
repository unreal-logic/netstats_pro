import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Generic bottom-sheet picker helper ──────────────────────────────────────
// Used by both MatchDetailsStep (Competition, Venue) and TeamsSetupStep.

void showPickerSheet<T>({
  required BuildContext context,
  required String title,
  required IconData icon,
  required List<T> items,
  required int? selectedId,
  required String Function(T) getLabel,
  required int Function(T) getId,
  required void Function(int id) onSelected,
  required void Function(String name, Color? color) onQuickCreate,
  required IconData emptyIcon,
  required String emptyTitle,
  required String emptySubtitle,
  required String createLabel,
  Widget? Function(T, {required bool isSelected})? getLeading,
  List<Color>? colorOptions,
}) {
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PickerBottomSheet<T>(
        title: title,
        icon: icon,
        items: items,
        selectedId: selectedId,
        getLabel: getLabel,
        getId: getId,
        onSelected: (id) {
          onSelected(id);
          Navigator.of(context).pop();
        },
        onQuickCreate: onQuickCreate,
        emptyIcon: emptyIcon,
        emptyTitle: emptyTitle,
        emptySubtitle: emptySubtitle,
        createLabel: createLabel,
        getLeading: (item, {required isSelected}) =>
            getLeading?.call(item, isSelected: isSelected),
        colorOptions: colorOptions,
      ),
    ),
  );
}

// ─── Tappable field that triggers the bottom sheet ───────────────────────────

class PickerField extends StatelessWidget {
  const PickerField({
    required this.placeholder,
    required this.icon,
    required this.onTap,
    super.key,
    this.label,
  });

  final String? label;
  final String placeholder;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasValue = label != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue
                ? cs.primary.withValues(alpha: 0.6)
                : cs.outline.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: hasValue ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label ?? placeholder,
                style: TextStyle(
                  color: hasValue ? cs.onSurface : cs.onSurfaceVariant,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              hasValue ? Icons.check_circle_outline : Icons.chevron_right,
              size: 20,
              color: hasValue ? cs.primary : cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── The actual bottom sheet content ─────────────────────────────────────────

class PickerBottomSheet<T> extends StatefulWidget {
  const PickerBottomSheet({
    required this.title,
    required this.icon,
    required this.items,
    required this.selectedId,
    required this.getLabel,
    required this.getId,
    required this.onSelected,
    required this.onQuickCreate,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.createLabel,
    super.key,
    this.getLeading,
    this.colorOptions,
  });

  final String title;
  final IconData icon;
  final List<T> items;
  final int? selectedId;
  final String Function(T) getLabel;
  final int Function(T) getId;
  final void Function(int) onSelected;
  final void Function(String, Color?) onQuickCreate;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final String createLabel;
  final Widget? Function(T, {required bool isSelected})? getLeading;
  final List<Color>? colorOptions;

  @override
  State<PickerBottomSheet<T>> createState() => _PickerBottomSheetState<T>();
}

class _PickerBottomSheetState<T> extends State<PickerBottomSheet<T>> {
  late TextEditingController _searchController;
  late TextEditingController _createController;
  bool _showCreateForm = false;
  String _query = '';
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _createController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _createController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PickerBottomSheet<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.colorOptions != oldWidget.colorOptions &&
        widget.colorOptions != null) {
      _selectedColor ??= widget.colorOptions!.first;
    }
  }

  List<T> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items
        .where((item) => widget.getLabel(item).toLowerCase().contains(q))
        .toList();
  }

  void _submitCreate() {
    final name = _createController.text.trim();
    if (name.isEmpty) return;
    unawaited(HapticFeedback.mediumImpact());
    widget.onQuickCreate(name, _selectedColor);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _filtered;
    final isEmpty = widget.items.isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(widget.icon, color: cs.primary, size: 22),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          if (isEmpty && !_showCreateForm)
            PickerEmptyState(
              icon: widget.emptyIcon,
              title: widget.emptyTitle,
              subtitle: widget.emptySubtitle,
              createLabel: widget.createLabel,
              onCreateTap: () => setState(() => _showCreateForm = true),
            )
          else if (!isEmpty && !_showCreateForm) ...[
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search ${widget.title.toLowerCase()}s...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() {
                            _query = '';
                            _searchController.clear();
                          }),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
              ),
            ),
            // List
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 36,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No results for "$_query"',
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: 56),
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];
                        final id = widget.getId(item);
                        final isSelected = id == widget.selectedId;
                        return ListTile(
                          leading:
                              widget.getLeading?.call(
                                item,
                                isSelected: isSelected,
                              ) ??
                              Icon(
                                widget.icon,
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurfaceVariant,
                                size: 20,
                              ),
                          title: Text(
                            widget.getLabel(item),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected ? cs.primary : cs.onSurface,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check, color: cs.primary)
                              : null,
                          onTap: () {
                            unawaited(HapticFeedback.selectionClick());
                            widget.onSelected(id);
                          },
                        );
                      },
                    ),
            ),
            // Add new footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showCreateForm = true),
                icon: const Icon(Icons.add, size: 18),
                label: Text('+ ${widget.createLabel}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ),
          ],

          // Quick-create form
          if (_showCreateForm)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.createLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _createController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) => _submitCreate(),
                    decoration: InputDecoration(
                      hintText: 'Enter ${widget.title.toLowerCase()} name',
                      prefixIcon: Icon(widget.icon),
                    ),
                  ),
                  if (widget.colorOptions != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'TEAM COLOR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.colorOptions!.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final color = widget.colorOptions![i];
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? cs.onSurface
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 18,
                                      color: color.computeLuminance() > 0.5
                                          ? Colors.black87
                                          : Colors.white,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() {
                            _showCreateForm = false;
                            _createController.clear();
                          }),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _submitCreate,
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────

class PickerEmptyState extends StatelessWidget {
  const PickerEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.createLabel,
    required this.onCreateTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String createLabel;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: cs.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onCreateTap,
            icon: const Icon(Icons.add, size: 18),
            label: Text(createLabel),
            style: FilledButton.styleFrom(minimumSize: const Size(200, 48)),
          ),
        ],
      ),
    );
  }
}
