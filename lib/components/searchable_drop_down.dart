import 'package:flutter/material.dart';
import 'package:github_inspection/api_calls/modal_responses.dart';

class SearchableDropdown extends StatefulWidget {
  final String label, hint;
  final List<DropdownItem>? items;
  final DropdownItem? selected;
  final ValueChanged<DropdownItem> onChanged;
  final bool enabled;
  const SearchableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    this.hint = 'Select',
  });
  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _controller = TextEditingController();
  List<DropdownItem> _filtered = [];

  Future<void> _openSheet() async {
    if (!widget.enabled) return;
    if (widget.items == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Loading options...')));
      return;
    }
    _controller.text = '';
    _filtered = List.from(widget.items!);
    await showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: 8,
              right: 8,
              bottom: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search ${widget.label.toLowerCase()}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  onChanged: (q) => setModalState(
                    () => _filtered = widget.items!
                        .where(
                          (e) => e.name.toLowerCase().contains(q.toLowerCase()),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No ${widget.label.toLowerCase()} found.',
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filtered.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, idx) {
                            final it = _filtered[idx],
                                isSelected = widget.selected?.id == it.id;
                            return ListTile(
                              title: Text(it.name),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                Navigator.of(context).pop();
                                widget.onChanged(it);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final display = widget.selected?.name ?? widget.hint,
        isEnabled = widget.enabled && widget.items != null;
    return FormField<DropdownItem>(
      validator: (value) {
        if (widget.selected == null) {
          return 'Please select ${widget.label.toLowerCase()}';
        }
        return null;
      },
      builder: (FormFieldState<DropdownItem> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: isEnabled ? _openSheet : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  errorText: state.errorText,
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(display)),
                    if (!isEnabled)
                      const Icon(Icons.lock, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
