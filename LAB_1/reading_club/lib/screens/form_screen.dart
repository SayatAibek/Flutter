import 'package:flutter/material.dart';

import '../models/book.dart';
import '../utils/format.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({this.initial, super.key});

  final Book? initial;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _placeFocus = FocusNode();
  final FocusNode _limitFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _timeFocus = FocusNode();

  BookGenre? _genre;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _mode = false;
  bool _saving = false;
  bool _allowPop = false;
  String _originalTitle = '';
  String _originalPlace = '';
  String _originalLimit = '';
  String _originalDescription = '';
  BookGenre? _originalGenre;
  DateTime? _originalWhen;
  bool _originalMode = false;

  DateTime? get _combinedDateTime {
    final date = _selectedDate;
    final time = _selectedTime;
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool get _dirty {
    return _titleController.text != _originalTitle ||
        _placeController.text != _originalPlace ||
        _limitController.text != _originalLimit ||
        _descriptionController.text != _originalDescription ||
        _genre != _originalGenre ||
        _mode != _originalMode ||
        _combinedDateTime != _originalWhen;
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    final defaults = Book.empty();
    _titleController.text = initial?.title ?? defaults.title;
    _placeController.text = initial?.location ?? defaults.location;
    _limitController.text = (initial?.limit ?? defaults.limit).toString();
    _descriptionController.text = initial?.description ?? '';
    _genre = initial?.genre;
    _selectedDate = initial == null
        ? null
        : DateTime(initial.when.year, initial.when.month, initial.when.day);
    _selectedTime = initial == null
        ? null
        : TimeOfDay(hour: initial.when.hour, minute: initial.when.minute);
    _mode = initial?.mode ?? defaults.mode;
    if (_selectedDate != null) _dateController.text = formatDate(_selectedDate ?? DateTime.now());
    if (_selectedTime != null) {
      final time = _selectedTime;
      if (time != null) {
        _timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
    }

    _originalTitle = _titleController.text;
    _originalPlace = _placeController.text;
    _originalLimit = _limitController.text;
    _originalDescription = _descriptionController.text;
    _originalGenre = _genre;
    _originalWhen = initial?.when;
    _originalMode = _mode;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _limitController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _titleFocus.dispose();
    _placeFocus.dispose();
    _limitFocus.dispose();
    _descriptionFocus.dispose();
    _dateFocus.dispose();
    _timeFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
      _dateController.text = formatDate(picked);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _selectedTime = picked;
      _timeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    });
  }

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.length < 3 || title.length > 60) return 'Title must be 3–60 characters.';
    return null;
  }

  String? _validatePlace(String? value) {
    final place = value?.trim() ?? '';
    if (place.isEmpty) return _mode ? 'Meeting link is required.' : 'Place is required.';
    if (_mode && !place.contains('://')) return 'Online link must contain ://.';
    return null;
  }

  String? _validateLimit(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 1 || parsed > 500) return 'Enter a whole number from 1 to 500.';
    final currentCount = widget.initial?.count ?? 0;
    if (parsed < currentCount) return 'Limit cannot be below the current count ($currentCount).';
    return null;
  }

  String? _validateDate(String? value) {
    if (_selectedDate == null) return 'Choose a meeting date.';
    if (_selectedTime == null) return 'Choose a meeting time too.';
    if (widget.initial == null) {
      final combined = _combinedDateTime;
      if (combined != null && !combined.isAfter(DateTime.now())) {
        return 'A new meeting must be in the future.';
      }
    }
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final selectedGenre = _genre;
    final meetingTime = _combinedDateTime;
    final limit = int.tryParse(_limitController.text.trim());
    if (selectedGenre == null || meetingTime == null || limit == null) return;

    final description = _descriptionController.text.trim();
    final result = Book(
      title: _titleController.text.trim(),
      genre: selectedGenre,
      when: meetingTime,
      limit: limit,
      names: widget.initial?.names ?? const <String>[],
      mode: _mode,
      location: _placeController.text.trim(),
      description: description.isEmpty ? null : description,
      favourite: widget.initial?.favourite ?? false,
    );

    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  Future<void> _confirmDiscard() async {
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your unsaved changes will be lost.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (!mounted || shouldDiscard != true) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Book>(
      canPop: !_dirty || _allowPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !_dirty || _saving) return;
        await _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.initial == null ? 'Add a book' : 'Edit book')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  maxLength: 60,
                  validator: _validateTitle,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _placeFocus.requestFocus(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    labelText: 'Book title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<BookGenre>(
                  initialValue: _genre,
                  decoration: const InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(),
                  ),
                  items: <DropdownMenuItem<BookGenre>>[
                    for (final genre in BookGenre.values)
                      DropdownMenuItem<BookGenre>(
                        value: genre,
                        child: Row(
                          children: <Widget>[
                            Icon(genre.icon, size: 18),
                            const SizedBox(width: 8),
                            Text(genre.label),
                          ],
                        ),
                      ),
                  ],
                  validator: (value) => value == null ? 'Choose a genre.' : null,
                  onChanged: (value) => setState(() => _genre = value),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _mode,
                  title: const Text('Online meeting'),
                  subtitle: const Text('When enabled, enter a URL instead of a physical place.'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) => setState(() => _mode = value ?? false),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _placeController,
                  focusNode: _placeFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: _mode ? TextInputType.url : TextInputType.streetAddress,
                  validator: _validatePlace,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _limitFocus.requestFocus(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    labelText: _mode ? 'Meeting URL' : 'Meeting place',
                    hintText: _mode ? 'https://...' : 'Library, room, or address',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _limitController,
                  focusNode: _limitFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: _validateLimit,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _dateFocus.requestFocus(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    labelText: 'Reader limit',
                    helperText: 'Whole number from 1 to 500',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        focusNode: _dateFocus,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        validator: _validateDate,
                        onTap: _pickDate,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: const InputDecoration(
                          labelText: 'Meeting date',
                          suffixIcon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        focusNode: _timeFocus,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) => _selectedTime == null ? 'Choose a time.' : null,
                        onTap: _pickTime,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: const InputDecoration(
                          labelText: 'Meeting time',
                          suffixIcon: Icon(Icons.schedule),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save book'),
          ),
        ),
      ),
    );
  }
}
