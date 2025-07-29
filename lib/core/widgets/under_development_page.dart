import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import '../../features/dashboard/controller/app_drawer_controller.dart';
import '../constants/radius_utils.dart';
import '../router/app_router.dart';

class UnderDevelopmentPage extends StatefulWidget {
  const UnderDevelopmentPage({Key? key}) : super(key: key);

  @override
  State<UnderDevelopmentPage> createState() => _UnderDevelopmentPageState();
}

class _UnderDevelopmentPageState extends State<UnderDevelopmentPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00457A),
              Color(0xFF667eea),
              Color(0xFF3700B3),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.laptop_chromebook_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Main Title
                  Text(
                    'Under Development',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  // Subtitle
                  Text(
                    'We\'re working hard to bring you\nsomething amazing!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Coming Soon
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Other Modules Are Coming Soon:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: DeviceType.isMobile(context) ? 15 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Main Coming Soon Feature Section
                  DeviceType.isMobile(context)
                    ? Column(
                    spacing: 10,
                    children: [
                      _buildModuleSection('🏭 Production', [
                        'Yield Sheet',
                      ]),
                      10.widthGap,
                      _buildModuleSection('📦 Sales', [
                        'Sales Quotation',
                        'Sales Order',
                        'Sales Debit Note',
                        'Sales Credit Note',
                      ]),
                      10.widthGap,
                      _buildModuleSection('🛒 Purchase', [
                        'Purchase Indent',
                        'Purchase Order',
                        'Gate Inward',
                        'Goods Receipt Note',
                        'Purchase Bill',
                        'Purchase Credit Note',
                        'Purchase Debit Note',
                      ]),
                    ],
                  ): Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildModuleSection('🏭 Production', [
                        'Yield Sheet',
                      ]),
                      10.widthGap,
                      _buildModuleSection('📦 Sales', [
                        'Sales Quotation',
                        'Sales Order',
                        'Sales Debit Note',
                        'Sales Credit Note',
                      ]),
                      10.widthGap,
                      _buildModuleSection('🛒 Purchase', [
                        'Purchase Indent',
                        'Purchase Order',
                        'Gate Inward',
                        'Goods Receipt Note',
                        'Purchase Bill',
                        'Purchase Credit Note',
                        'Purchase Debit Note',
                      ]),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 45,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: RadiusUtils.borderRadiusForButtons,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.find<AppDrawerController>().sideBarXController.selectIndex(0);
                        Get.offAllNamed(AppRouter.dashboardScreen);
                      },
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColors.darkButtonColor
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: RadiusUtils.borderRadiusForButtons,
                          ),
                        ),
                      ), child: Row(
                      children: [
                        Icon(Icons.dashboard),
                        5.widthGap,
                        Text('Go to Dashboard'),
                      ],
                    ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModuleSection(String title, List<String> subModules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.amberAccent.shade100,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        ...subModules.map(
              (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.subdirectory_arrow_right,color: Colors.grey,),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}