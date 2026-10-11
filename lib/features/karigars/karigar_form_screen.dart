import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/unsaved_changes_guard.dart';
import 'karigar_providers.dart';

class KarigarFormScreen extends ConsumerStatefulWidget {
  const KarigarFormScreen({super.key, this.karigar});

  final Karigar? karigar;

  @override
  ConsumerState<KarigarFormScreen> createState() => _KarigarFormScreenState();
}

class _KarigarFormScreenState extends ConsumerState<KarigarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _skills;
  late final TextEditingController _notes;
  bool _saving = false;
  bool _saved = false;

  bool get _editing => widget.karigar != null;

  @override
  void initState() {
    super.initState();
    final karigar = widget.karigar;
    _name = TextEditingController(text: karigar?.name ?? '');
    _phone = TextEditingController(text: karigar?.phone ?? '');
    _address = TextEditingController(text: karigar?.address ?? '');
    _skills = TextEditingController(text: karigar?.skills ?? '');
    _notes = TextEditingController(text: karigar?.notes ?? '');
    for (final controller in [_name, _phone, _address, _skills, _notes]) {
      controller.addListener(_refreshDirtyState);
    }
  }

  void _refreshDirtyState() {
    if (mounted) setState(() {});
  }

  bool get _hasUnsavedChanges {
    if (_saved) return false;
    final karigar = widget.karigar;
    return _name.text != (karigar?.name ?? '') ||
        _phone.text != (karigar?.phone ?? '') ||
        _address.text != (karigar?.address ?? '') ||
        _skills.text != (karigar?.skills ?? '') ||
        _notes.text != (karigar?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _skills.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final dao = ref.read(karigarsDaoProvider);
      final existing = widget.karigar;
      if (existing == null) {
        await dao.createKarigar(
          name: _name.text,
          phone: _phone.text,
          address: _address.text,
          skills: _skills.text,
          notes: _notes.text,
        );
      } else {
        await dao.updateKarigar(
          id: existing.id,
          name: _name.text,
          phone: _phone.text,
          address: _address.text,
          skills: _skills.text,
          notes: _notes.text,
        );
      }
      if (mounted) {
        setState(() => _saved = true);
        await WidgetsBinding.instance.endOfFrame;
        if (mounted) Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save karigar. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnsavedChangesGuard(
      hasUnsavedChanges: _hasUnsavedChanges,
      child: Scaffold(
        appBar: AppBar(title: Text(_editing ? 'Edit Karigar' : 'Add Karigar')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: AppSpacing.pagePadding,
              children: [
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  autofocus: !_editing,
                  decoration: const InputDecoration(labelText: 'Name *'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter the karigar name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _address,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _skills,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Garment skills',
                    hintText: 'Shirt, trouser, waistcoat',
                    helperText: 'Separate multiple skills with commas.',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _notes,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: AppSpacing.xxl),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Saving…' : 'Save Karigar'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
