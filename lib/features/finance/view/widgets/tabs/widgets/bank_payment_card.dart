import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/app_pdf_viewer.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/finance/controller/bank_payment_controller.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';

class PaymentCard extends StatelessWidget {
  final BankPaymentModel payment;
  final Color primaryColor;
  final VoidCallback onTap;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PaymentCard({
    Key? key,
    required this.payment,
    required this.primaryColor,
    required this.onTap,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy');

    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(payment.docdate ?? '');
    } catch (e) {
      parsedDate = null;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        payment.type ?? 'N/A',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Obx(() {
                      return IconButton(
                        onPressed:
                            (payment.isPdfLoading?.value ?? false)
                                ? null
                                : () async {
                                  final pdf =
                                      await Get.find<BankPaymentController>()
                                          .getBankPaymentReport(payment);
                                  if (pdf != null) {
                                    Get.to(AppPdfViewer(pdfFile: pdf));
                                  }
                                },
                        icon:
                            (payment.isPdfLoading?.value ?? false)
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: FittedBox(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                                : Icon(
                                  Icons.picture_as_pdf,
                                  size: 20,
                                  color: AppColors.blue,
                                ),
                      );
                    }),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            (payment.authorise ?? false)
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            (payment.authorise ?? false)
                                ? Icons.check_circle
                                : Icons.pending,
                            size: 12,
                            color:
                                (payment.authorise ?? false)
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                          SizedBox(width: 4),
                          Text(
                            (payment.authorise ?? false)
                                ? 'Authorise'
                                : 'Unauthorise',
                            style: TextStyle(
                              color:
                                  (payment.authorise ?? false)
                                      ? Colors.green
                                      : Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Party Name
                Text(
                  payment.party ?? 'Unknown Party',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),

                SizedBox(height: 8),

                // Amount
                Text(
                  currencyFormat.format(payment.amount ?? 0),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                SizedBox(height: 8),

                // Description
                if (payment.narr != null && payment.narr!.isNotEmpty)
                  Text(
                    payment.narr!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                SizedBox(height: 12),

                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          parsedDate != null
                              ? dateFormat.format(parsedDate)
                              : payment.docdate ?? 'N/A',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.receipt, size: 16, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          '#${payment.srl ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: () {},
                        text: "Approve",
                        backgroundColor: AppColors.success,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        onPressed: () {},
                        text: "Reject",
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
