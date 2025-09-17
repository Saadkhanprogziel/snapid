import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/controllers/ticket_management/ticket_management_controller.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_header.dart';
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
                  child: CustomHeader(
                    title: "Ticket Management",
                    showBackButton: true,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpaceH30(),
                        _buildCustomTabBar(),
                        SpaceH10(),
                        _buildTicketsList(
                          isWide,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            child: Text(
              "No tickets found",
              style: TextStyle(color: Colors.white),
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
                  'subject': 'Photo Upload Issue',
                  'status': 'Open',
                  'date': 'Sep 17, 2024',
                  'ticketId': '#T12345'
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
              child: TicketCard(
                subject: ticket.title,
                status: ticket.status,
                updatedDate:
                    displayUpdatedDate(ticket.closedAt, ticket.createdAt),
                description: ticket.description,
              ),
            );
          }).toList(),
        );
      }
    });
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
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
      ),
    );
  }
}
