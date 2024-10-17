import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/src/user/all_orders.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> _handleLogout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      User user = userProvider.user;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          centerTitle: false,
          leadingWidth: 24,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("My Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          // padding: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),

                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade100,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                  size: 65,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name ?? 'N/A',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "+91 ${user.phone}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Text(
                                  user.address ?? "N/A",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.edit,
                        //     size: 18,
                        //     color: Colors.grey.shade500,
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    )),
              ),
              const SizedBox(height: 16),
              const Text(
                "YOUR INFORMATION",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      //orders
                      _buildInfoRow(
                        const Icon(
                          Icons.shopping_bag_outlined,
                        ),
                        "Your Orders",
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AllOrdersPage()));
                        },
                      ),
                      // _buildInfoRow(
                      //     const Icon(
                      //       Icons.add_location_alt_outlined,
                      //     ),
                      //     "Address Book"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "ACTIONS",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      //orders

                      _buildInfoRow(
                        const Icon(
                          Icons.logout,
                        ),
                        "Log Out",
                        onTap: _handleLogout,
                      ),

                      //privacy policy
                      _buildInfoRow(
                        const Icon(
                          Icons.privacy_tip,
                        ),
                        "Privacy Policy",
                        onTap: () {
                          context.go('/privacy-policy');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _buildInfoRow(Icon icon, String title, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 16),
            Text(title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade500,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
