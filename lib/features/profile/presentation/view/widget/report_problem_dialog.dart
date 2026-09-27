import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';

class ReportProblemDialog extends ConsumerStatefulWidget {
  const ReportProblemDialog({super.key});

  @override
  ConsumerState<ReportProblemDialog> createState() =>
      _ReportProblemDialogState();
}

class _ReportProblemDialogState extends ConsumerState<ReportProblemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _reportType = 'bug';
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.reportProblem),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.reportProblemDetails),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                initialValue: _reportType,
                decoration: InputDecoration(labelText: AppStrings.reportType),
                items: [
                  DropdownMenuItem(
                    value: 'bug',
                    child: Text(AppStrings.bugReport),
                  ),
                  DropdownMenuItem(
                    value: 'suggestion',
                    child: Text(AppStrings.suggestionReport),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text(AppStrings.otherReport),
                  ),
                ],
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        if (value != null) setState(() => _reportType = value);
                      },
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _messageController,
                minLines: 3,
                maxLines: 5,
                maxLength: 1000,
                enabled: !_isSubmitting,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: AppStrings.reportMessage,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value?.trim().isNotEmpty == true
                    ? null
                    : AppStrings.reportMessageRequired,
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 8.h),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.red),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                child: Text(AppStrings.cancel),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: SizedBox(
                height: 44.h,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(AppStrings.submit),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (Supabase.instance.client.auth.currentUser == null) {
      setState(() => _errorMessage = AppStrings.signInToReport);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await ref.read(profileRepoProvider).submitProblemReport(
          reportType: _reportType,
          message: _messageController.text,
        );

    if (!mounted) return;
    result.when(
      sucess: (_) {
        Navigator.of(context).pop();
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(AppStrings.reportSubmitted)),
        );
      },
      failure: (error) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = error.message ?? AppStrings.unknownErrorOccurred;
        });
      },
    );
  }
}
