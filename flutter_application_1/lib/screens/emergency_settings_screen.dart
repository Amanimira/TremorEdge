import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tremor_ring_app/services/emergency_service.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class EmergencySettingsScreen extends StatefulWidget {
  const EmergencySettingsScreen({super.key});

  @override
  State<EmergencySettingsScreen> createState() =>
      _EmergencySettingsScreenState();
}

class _EmergencySettingsScreenState extends State<EmergencySettingsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRelation = 'ابن';

  final List<String> _relations = [
    'ابن',
    'ابنة',
    'الزوج',
    'الزوجة',
    'الأب',
    'الأم',
    'الطبيب',
    'ممرضة',
    'صديق',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyService>(
      builder: (context, emergencyService, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('إعدادات الطوارئ'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: AppColors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.emergency, color: AppColors.error),
                            const SizedBox(width: 12),
                            Text(
                              'إضافة جهة اتصال طوارئ',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'الاسم',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedRelation,
                          decoration: InputDecoration(
                            labelText: 'العلاقة',
                            prefixIcon: const Icon(Icons.family_restroom),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _relations
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedRelation = value ?? 'ابن');
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addContact,
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة جهة اتصال'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'جهات الاتصال المحفوظة (${emergencyService.contacts.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (emergencyService.contacts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.person_add,
                            size: 64,
                            color: AppColors.border,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد جهات اتصال محفوظة',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: emergencyService.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = emergencyService.contacts[index];
                      return _buildContactCard(
                        context,
                        contact,
                        emergencyService,
                        index,
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    dynamic contact,
    EmergencyService emergencyService,
    int index,
  ) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      contact.relation,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (contact.isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentGreen),
                    ),
                    child: Text(
                      'جهة أساسية ⭐',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  contact.phone,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        emergencyService.makeEmergencyCall(
                          phoneNumber: contact.phone,
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.call),
                    label: const Text('اتصال'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () =>
                      emergencyService.deleteContact(index),
                  icon: const Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addContact() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    context.read<EmergencyService>().addContact(
      name: _nameController.text,
      phone: _phoneController.text,
      relation: _selectedRelation,
      isPrimary: context.read<EmergencyService>().contacts.isEmpty,
    );

    _nameController.clear();
    _phoneController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة جهة الاتصال بنجاح')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}