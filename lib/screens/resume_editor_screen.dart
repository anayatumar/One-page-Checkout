import 'dart:typed_data';
import 'package:flutter/material.dart' hide Icons;
import 'package:flutter/material.dart' as m show Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../models/resume.dart';
import '../providers/resume_provider.dart';
import '../templates/modern_template.dart';
import '../templates/classic_template.dart';
import '../templates/creative_template.dart';

class ResumeEditorScreen extends ConsumerStatefulWidget {
  final Resume? resume;

  const ResumeEditorScreen({super.key, this.resume});

  @override
  ConsumerState<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends ConsumerState<ResumeEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _summaryController;

  List<Experience> _experience = [];
  List<Education> _education = [];
  List<Skill> _skills = [];
  String _selectedTemplate = 'Modern';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.resume?.title ?? 'Professional CV');
    _firstNameController = TextEditingController(text: widget.resume?.personalInfo.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.resume?.personalInfo.lastName ?? '');
    _emailController = TextEditingController(text: widget.resume?.personalInfo.email ?? '');
    _phoneController = TextEditingController(text: widget.resume?.personalInfo.phone ?? '');
    _addressController = TextEditingController(text: widget.resume?.personalInfo.address ?? '');
    _summaryController = TextEditingController(text: widget.resume?.summary ?? '');
    _experience = widget.resume?.experience.toList() ?? [];
    _education = widget.resume?.education.toList() ?? [];
    _skills = widget.resume?.skills.toList() ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Resume _getResume() {
    final personalInfo = PersonalInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    return (widget.resume ?? Resume(
      title: _titleController.text,
      personalInfo: personalInfo,
    )).copyWith(
      title: _titleController.text,
      personalInfo: personalInfo,
      summary: _summaryController.text,
      experience: _experience,
      education: _education,
      skills: _skills,
    );
  }

  void _saveResume() {
    ref.read(resumeListProvider.notifier).saveResume(_getResume());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CV Saved Successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _previewPDF() async {
    final resume = _getResume();
    Uint8List pdfBytes;

    switch (_selectedTemplate) {
      case 'Classic':
        pdfBytes = await ClassicTemplate.generate(resume);
        break;
      case 'Creative':
        pdfBytes = await CreativeTemplate.generate(resume);
        break;
      case 'Modern':
      default:
        pdfBytes = await ModernTemplate.generate(resume);
    }

    if (!mounted) return;

    await Printing.layoutPdf(
      onLayout: (format) => pdfBytes,
      name: '${resume.title}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        appBar: AppBar(
          title: Text(widget.resume == null ? 'New CV' : 'Edit CV'),
          actions: [
            IconButton(
              icon: const Icon(m.Icons.remove_red_eye_outlined),
              onPressed: _previewPDF,
              tooltip: 'Preview PDF',
            ),
            IconButton(
              icon: const Icon(m.Icons.save_outlined),
              onPressed: _saveResume,
              tooltip: 'Save CV',
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'PERSONAL'),
              Tab(text: 'EXPERIENCE'),
              Tab(text: 'EDUCATION'),
              Tab(text: 'SKILLS'),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        body: TabBarView(
          children: [
            _buildPersonalInfoTab(),
            _buildExperienceTab(),
            _buildEducationTab(),
            _buildSkillsTab(),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTemplate,
                      items: ['Modern', 'Classic', 'Creative'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (val) => setState(() => _selectedTemplate = val!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _previewPDF,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('GENERATE PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection('General Information', [
            _buildTextField(_titleController, 'CV Title', 'e.g., Senior Developer CV', m.Icons.title),
          ]),
          const SizedBox(height: 24),
          _buildFormSection('Contact Details', [
            Row(
              children: [
                Expanded(child: _buildTextField(_firstNameController, 'First Name', 'John', m.Icons.person_outline)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_lastNameController, 'Last Name', 'Doe', m.Icons.person_outline)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email', 'john.doe@example.com', m.Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone', '+1 234 567 890', m.Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_addressController, 'Address', 'City, Country', m.Icons.location_on_outlined),
          ]),
          const SizedBox(height: 24),
          _buildFormSection('Professional Summary', [
            _buildTextField(_summaryController, 'Profile Summary', 'Short professional bio...', m.Icons.description_outlined, maxLines: 5),
          ]),
        ],
      ),
    );
  }

  Widget _buildExperienceTab() {
    return _buildListTab(
      _experience,
      (index) {
        final exp = _experience[index];
        return _buildListItem(
          exp.position,
          '${exp.company} | ${exp.startDate} - ${exp.isCurrent ? 'Present' : exp.endDate}',
          () => setState(() => _experience.removeAt(index)),
        );
      },
      'No experience added yet.',
      'Add Experience',
      _showAddExperienceDialog,
    );
  }

  Widget _buildEducationTab() {
    return _buildListTab(
      _education,
      (index) {
        final edu = _education[index];
        return _buildListItem(
          edu.degree,
          '${edu.institution} | ${edu.startDate} - ${edu.endDate}',
          () => setState(() => _education.removeAt(index)),
        );
      },
      'No education added yet.',
      'Add Education',
      _showAddEducationDialog,
    );
  }

  Widget _buildSkillsTab() {
    return _buildListTab(
      _skills,
      (index) {
        final skill = _skills[index];
        return _buildListItem(
          skill.name,
          'Proficiency: ${(skill.level * 100).toInt()}%',
          () => setState(() => _skills.removeAt(index)),
        );
      },
      'No skills added yet.',
      'Add Skill',
      _showAddSkillDialog,
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }

  Widget _buildListTab(List list, Widget Function(int) itemBuilder, String emptyMsg, String btnLabel, VoidCallback onAdd) {
    return Column(
      children: [
        Expanded(
          child: list.isEmpty
              ? Center(child: Text(emptyMsg, style: const TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) => itemBuilder(index),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(m.Icons.add),
            label: Text(btnLabel),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(String title, String subtitle, VoidCallback onDelete) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: IconButton(icon: const Icon(m.Icons.delete_outline, color: Colors.red), onPressed: onDelete),
      ),
    );
  }

  void _showAddExperienceDialog() {
    final companyController = TextEditingController();
    final positionController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();
    final descController = TextEditingController();
    bool isCurrent = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Experience'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(positionController, 'Position', 'Software Engineer', m.Icons.work_outline),
                const SizedBox(height: 12),
                _buildTextField(companyController, 'Company', 'Google', m.Icons.business_outlined),
                const SizedBox(height: 12),
                _buildTextField(startController, 'Start Date', 'Jan 2020', m.Icons.calendar_today_outlined),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text('Current Position'),
                  value: isCurrent,
                  onChanged: (val) => setDialogState(() => isCurrent = val!),
                  contentPadding: EdgeInsets.zero,
                ),
                if (!isCurrent) ...[
                  const SizedBox(height: 12),
                  _buildTextField(endController, 'End Date', 'Present', m.Icons.calendar_today_outlined),
                ],
                const SizedBox(height: 12),
                _buildTextField(descController, 'Description', 'Responsibilities...', m.Icons.description_outlined, maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _experience.add(Experience(
                    company: companyController.text,
                    position: positionController.text,
                    startDate: startController.text,
                    endDate: isCurrent ? null : endController.text,
                    isCurrent: isCurrent,
                    description: descController.text,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEducationDialog() {
    final institutionController = TextEditingController();
    final degreeController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Education'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(degreeController, 'Degree', 'B.Sc. Computer Science', m.Icons.school_outlined),
              const SizedBox(height: 12),
              _buildTextField(institutionController, 'Institution', 'Harvard University', m.Icons.account_balance_outlined),
              const SizedBox(height: 12),
              _buildTextField(startController, 'Start Date', '2016', m.Icons.calendar_today_outlined),
              const SizedBox(height: 12),
              _buildTextField(endController, 'End Date', '2020', m.Icons.calendar_today_outlined),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _education.add(Education(
                  institution: institutionController.text,
                  degree: degreeController.text,
                  startDate: startController.text,
                  endDate: endController.text,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog() {
    final skillController = TextEditingController();
    double level = 0.5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Skill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(skillController, 'Skill Name', 'Flutter', m.Icons.star_outline),
              const SizedBox(height: 20),
              const Text('Proficiency Level'),
              Slider(
                value: level,
                onChanged: (val) => setDialogState(() => level = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _skills.add(Skill(name: skillController.text, level: level));
                });
                Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}
