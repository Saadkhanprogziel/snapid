import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/controllers/ticket_management/ticket_management_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';
import 'package:snapid/utlis/custom_tabbar.dart';
import 'package:snapid/utlis/screenBg.dart';

class TicketManagement extends StatefulWidget {
  TicketManagement({super.key});

  @override
  State<TicketManagement> createState() => _TicketManagementState();
}

final TicketManagementController controller =
    Get.put(TicketManagementController());

class _TicketManagementState extends State<TicketManagement> {
  void _handleCreateTicket() {
    _showCreateTicketDialog();
  }

  void _showCreateTicketDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.cardColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(40, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Create New Ticket",
                            style: CustomTextTheme.regular20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Subject field
                    Text(
                      "Subject",

                      style: CustomTextTheme.regular14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      cursorColor: Colors.white, // 👈 Add this
                      controller: controller.subjectController,
                      style: CustomTextTheme.regular14.copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter ticket subject",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description field
                    Text(
                      "Description",
                      style: CustomTextTheme.regular14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      cursorColor: Colors.white, // 👈 Add this

                      controller: controller.descriptionController,
                      maxLines: 4,
                      style: CustomTextTheme.regular14.copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Describe your issue or request...",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                            child: CustomOutlineButton(
                                onPressed: () {
                                  Get.back();
                                },
                                label: "Cancel")),
                        const SizedBox(width: 16),
                        Expanded(
                            child: CustomElevatedButton(
                                onPressed: () {
                                  controller.createTicket();
                                },
                                text: "Create Ticket")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isWide = deviceWidth >= 800;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          buildBackground(),
          Padding(
            padding: EdgeInsets.all(isWide ? 50.0 : 0),
            child: Column(
              children: [
                SafeArea(
                  child: _buildHeader(isWide),
                ),
                _buildCustomTabBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpaceH10(),
                        _buildTicketsList(isWide),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // FAB for mobile only
      floatingActionButton: !isWide ? _buildMobileFAB() : null,
    );
  }

  Widget _buildHeader(bool isWide) {
    if (isWide) {
      // Custom header for web with add button
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomHeader(
            showBackButton: true,
            title: "Ticket Management",
            rightWidget: _buildWebAddButton(),
          ));
    } else {
      // Original header for mobile
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CustomHeader(
          title: "Ticket Management",
          showBackButton: true,
        ),
      );
    }
  }

  Widget _buildWebAddButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(30, 255, 255, 255),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: _handleCreateTicket,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "New Ticket",
                    style: CustomTextTheme.regular14.copyWith(
                      fontWeight: FontWeight.w600,
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

  Widget _buildMobileFAB() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FloatingActionButton(
          onPressed: _handleCreateTicket,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildTicketsList(bool isWide) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }

      var tickets = controller.tickets;

      if (tickets.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  "No tickets found",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create your first ticket to get started",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                _buildEmptyStateButton(isWide),
              ],
            ),
          ),
        );
      }

      if (isWide) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 230,
          ),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(PrimaryRoute.chat_screen, arguments: {
                  'subject': ticket.title,
                  'status': ticket.status,
                  'date': displayUpdatedDate(ticket.closedAt, ticket.createdAt),
                  'ticketId': ticket.id,
                  'chat_id': ticket.chat.id
                });
              },
              child: TicketCard(
                subject: ticket.title,
                status: ticket.status,
                updatedDate:
                    displayUpdatedDate(ticket.closedAt, ticket.createdAt),
                description: ticket.description,
              ),
            );
          },
        );
      } else {
        return Column(
          children: tickets.map((ticket) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(PrimaryRoute.chat_screen, arguments: {
                    'subject': ticket.title,
                    'status': ticket.status,
                    'date':
                        displayUpdatedDate(ticket.closedAt, ticket.createdAt),
                    'ticketId': ticket.id,
                    'chat_id': ticket.chat.id
                  });
                },
                child: TicketCard(
                  subject: ticket.title,
                  status: ticket.status,
                  updatedDate:
                      displayUpdatedDate(ticket.closedAt, ticket.createdAt),
                  description: ticket.description,
                ),
              ),
            );
          }).toList(),
        );
      }
    });
  }

  Widget _buildEmptyStateButton(bool isWide) {
    if (isWide) {
      return _buildWebAddButton();
    }
    return SizedBox.shrink();
    // } else {
    //   return ElevatedButton.icon(
    //     onPressed: _handleCreateTicket,
    //     icon: const Icon(Icons.add_rounded, color: Colors.white),
    //     label: Text(
    //       "Create Ticket",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Colors.white.withOpacity(0.2),
    //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(25),
    //       ),
    //     ),
    //   );
    // }
  }

  String displayUpdatedDate(DateTime? closedAt, DateTime createdAt) {
    final date = closedAt ?? createdAt;
    return "${date.day}-${date.month}-${date.year}";
  }

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(20, 223, 222, 222),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(
                  () => TabBarWidgetFlexible(
                    tabs: ['All ', 'Open', 'Pending', "Closed"],
                    selectedIndex: controller.selectedTab.value,
                    onTabSelected: (index) {
                      controller.onTabChanged(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String subject;
  final String status;
  final String updatedDate;
  final String description;

  const TicketCard({
    Key? key,
    required this.subject,
    required this.status,
    required this.updatedDate,
    required this.description,
  }) : super(key: key);

  // Helper function to map status → background color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green.withOpacity(0.2);
      case 'pending':
        return Colors.orange.withOpacity(0.2);
      case 'closed':
        return Colors.red.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  // Helper function to map status → text color
  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(20, 223, 222, 222),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Subject
            Text(
              subject,
              style: CustomTextTheme.regular20,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SpaceH20(),

            /// Status row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status), // ✅ background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: CustomTextTheme.regular12.copyWith(
                      color: _getStatusTextColor(status), // ✅ text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SpaceW10(),
                Flexible(
                  child: Text(
                    'Updated: $updatedDate',
                    style: CustomTextTheme.regular12.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            SpaceH20(),

            /// Description
            Text(
              description,
              style: CustomTextTheme.regular12.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
