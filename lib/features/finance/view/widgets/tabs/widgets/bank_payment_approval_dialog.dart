import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';

class ApprovalDialog extends StatefulWidget {
  final String requestId;
  final bool isApproval;
  final Function(String remarks) onSubmit;

  const ApprovalDialog({
    Key? key,
    required this.requestId,
    required this.isApproval,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ApprovalDialog> createState() => _ApprovalDialogState();
}

class _ApprovalDialogState extends State<ApprovalDialog> {
  final TextEditingController _remarksController = TextEditingController();

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  widget.isApproval ? 'Approve Request' : 'Reject Request',
                  style: TextStyles.largeBold(
                    context,
                    textColor:
                        widget.isApproval
                            ? Colors.blue.shade700
                            : Colors.red.shade700,
                  ),
                  // ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 16),

            // Request ID
            Row(
              children: [
                AppText(
                  'Request ID: ',
                  style: TextStyles.mediumBold(
                    context,
                    textColor: Colors.black87,
                  ),
                ),
                AppText(
                  widget.requestId,
                  style: TextStyles.medium(
                    context,
                    textColor: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Remarks Section
            AppText(
              'Remarks',
              style: TextStyles.normal(context),
            ),
            const SizedBox(height: 12),

            // Remarks TextField
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _remarksController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      widget.isApproval
                          ? 'Enter approval remarks (optional)'
                          : 'Enter rejection reason (optional)',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(_remarksController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.isApproval
                            ? Colors.blue.shade600
                            : Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.isApproval ? 'Approve' : 'Reject',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
