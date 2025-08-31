import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_strings.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/utills/num_utils.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';

class VoucherCard extends StatelessWidget {
  final VoucherModel payment;
  final Color primaryColor;
  final VoidCallback? onTap;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onHold;

  const VoucherCard({
    Key? key,
    required this.payment,
    required this.primaryColor,
    this.onTap,
    required this.onApprove,
    required this.onReject,
    required this.onHold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'SRL-${payment.srl?.toString().padLeft(3, '0') ?? AppStrings.notAvailable}',
                        style: TextStyles.mediumBold(context),
                      ),
                      Spacer(),
                      Obx(
                        () =>
                            payment.isPdfLoading?.value == true
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Icon(
                                  Icons.picture_as_pdf,
                                  size: 20,
                                  color: AppColors.blue,
                                ),
                      ),
                      if (payment.isHold == true) ...[
                        SizedBox(width: 5),
                        Opacity(
                          opacity: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade600,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'ON HOLD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // if (payment.amount?.toInt() != 0 || payment.credit != 0)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         payment.debit?.toInt() == 0
                  //             ? '₹${formatAmount(payment.credit) ?? AppStrings.notAvailable}'
                  //             : '₹${formatAmount(payment.debit) ?? AppStrings.notAvailable}',
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //           color:
                  //               payment.debit?.toInt() == 0
                  //                   ? Colors.green
                  //                   : Colors.red,
                  //         ),
                  //       ),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 8,
                  //           vertical: 4,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color:
                  //               payment.debit?.toInt() == 0
                  //                   ? Colors.green.shade50
                  //                   : Colors.red.shade50,
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         child: AppText(
                  //           payment.debit?.toInt() == 0 ? 'Credit' : 'Debit',
                  //           style: TextStyles.normalBold(context),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  if ((payment.debit?.toInt() != 0 || payment.credit != 0) ||
                      (payment.debit?.toInt() == 0 && payment.credit == 0 && (payment.amount != null)))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payment.debit?.toInt() != 0
                              ? '₹${formatAmount(payment.debit) ?? AppStrings.notAvailable}'
                              : payment.credit != 0
                              ? '₹${formatAmount(payment.credit) ?? AppStrings.notAvailable}'
                              : '₹${formatAmount(payment.amount) ?? AppStrings.notAvailable}', // <-- new fallback
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: payment.debit?.toInt() != 0
                                ? Colors.red
                                : payment.credit != 0
                                ? Colors.green
                                : Colors.blue, // <-- color for amount
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: payment.debit?.toInt() != 0
                                ? Colors.red.shade50
                                : payment.credit != 0
                                ? Colors.green.shade50
                                : Colors.blue.shade50, // <-- background for amount
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: AppText(
                            payment.debit?.toInt() != 0
                                ? 'Debit'
                                : payment.credit != 0
                                ? 'Credit'
                                : 'Amount', // <-- label for amount
                            style: TextStyles.normalBold(context),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Bottom Info Section
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        payment.authIds ?? AppStrings.notAvailable,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        payment.mBranch ?? AppStrings.notAvailable,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${payment.subType} Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Type:',
                          payment.type ?? AppStrings.notAvailable,
                        ),
                        _buildDetailRow(
                          'Serial:',
                          payment.srl?.toString() ?? AppStrings.notAvailable,
                        ),
                        _buildDetailRow(
                          'Doc Date:',
                          payment.docDate ?? AppStrings.notAvailable,
                        ),
                        _buildDetailRow(
                          'Party Name:',
                          payment.party ?? AppStrings.notAvailable,
                        ),
                        _buildDetailRow(
                          'Reference:',
                          payment.linkField ?? AppStrings.notAvailable,
                        ),
                      ],
                    ),
                  ),
                  // Description
                  const SizedBox(height: 16),
                  if ((payment.narr ?? '').isNotEmpty) ...[
                    Text(
                      payment.narr ?? AppStrings.notAvailable,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onReject();
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
                      if (payment.isHold != true) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onHold();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Hold',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onApprove();
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
          if (payment.isHold == true)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'ON HOLD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
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
}
