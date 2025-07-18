import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/bank_payment_approval_dialog.dart';

class PaymentCard extends StatelessWidget {
  final BankPaymentModel payment;
  final Color primaryColor;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const PaymentCard({
    Key? key,
    required this.payment,
    required this.primaryColor,
    this.onTap,
    this.onApprove,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'REQ-${payment.srl?.toString().padLeft(3, '0') ?? '001'}',
                    style : TextStyles.mediumBold(context),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppText(
                          'High',
                          style : TextStyles.normalBold(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Obx(
                      //   () =>
                      //       payment.isPdfLoading?.value == true
                      //           ? const SizedBox(
                      //             width: 16,
                      //             height: 16,
                      //             child: CircularProgressIndicator(
                      //               strokeWidth: 2,
                      //             ),
                      //           )
                      //           : Icon(
                      //             Icons.picture_as_pdf,
                      //             color: Colors.red.shade600,
                      //             size: 20,
                      //           ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                '${payment.type ?? 'Bank Payment'} - Vendor Payment',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                payment.narr ??
                    'Payment to supplier for office supplies and equipment',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Bank Payment Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank Payment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Type:', payment.type ?? 'BNA'),
                    _buildDetailRow(
                      'Serial:',
                      payment.srl?.toString() ?? '000001',
                    ),
                    _buildDetailRow(
                      'Doc Date:',
                      payment.docDate ?? '01-Jul-2025',
                    ),
                    _buildDetailRow('Category:', 'Vendor Payment'),
                    _buildDetailRow(
                      'Party Name:',
                      payment.party ?? 'XYZ Industries Pvt Ltd',
                    ),
                    _buildDetailRow(
                      'Reference:',
                      payment.linkField ?? 'INV-2024-001',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Info Section
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text(
                    'Finance',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    payment.docDate ?? '2024-01-15',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${payment.credit?.toStringAsFixed(2) ?? '2,40,000.00'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // child: Text(
                    //   payment.authorise == true ? 'Approved' : 'Pending',
                    //   style: TextStyle(
                    //     color:
                    //         payment.authorise == true
                    //             ? Colors.green.shade700
                    //             : Colors.orange.shade700,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showApprovalDialog(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showApprovalDialog(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showApprovalDialog(BuildContext context, bool isApproval) {
    showDialog(
      context: context,
      builder:
          (context) => ApprovalDialog(
            requestId:
                'REQ-${payment.srl?.toString().padLeft(3, '0') ?? '001'}',
            isApproval: isApproval,
            onSubmit: (remarks) {
              if (isApproval) {
                onApprove?.call();
              } else {
                onReject?.call();
              }
              Get.back();
              // Handle the approval/rejection logic here
              Get.snackbar(
                isApproval ? 'Approved' : 'Rejected',
                'Request has been ${isApproval ? 'approved' : 'rejected'}${remarks.isNotEmpty ? ' with remarks: $remarks' : ''}',
                backgroundColor: isApproval ? Colors.green : Colors.red,
                colorText: Colors.white,
              );
            },
          ),
    );
  }
}
