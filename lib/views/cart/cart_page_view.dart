import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/utils/phonepe.dart';
import 'package:openzo_frontend/viewmodels/cart_page_view_model.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/views/cart/styles.dart';
import 'package:openzo_frontend/views/cart/succes_page.dart';
import 'package:openzo_frontend/views/cart/widgets/address_details.dart';
import 'package:openzo_frontend/views/cart/widgets/cart_item/cart_item.dart';
import 'package:openzo_frontend/views/cart/widgets/grad_button.dart';
import 'package:openzo_frontend/views/cart/widgets/order_status.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  final String id;

  const CartPage({super.key, required this.id});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  bool isAppBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final bool shouldCollapse = _scrollController.offset > (250 - kToolbarHeight);
    if (shouldCollapse != isAppBarCollapsed) {
      setState(() {
        isAppBarCollapsed = shouldCollapse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartPageViewModel(context, widget.id),
      child: Consumer<CartPageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cart == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Order Details')),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(height: 10),
                    Text('Order not found'),
                  ],
                ),
              ),
            );
          }

          return _buildbody(viewModel);
        },
      ),
    );
  }

  Widget _buildbody(CartPageViewModel viewModel){
    if (["not_placed", "cancelled", "rejected"].contains(viewModel.cart?.status)) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(title: const Text('Order Details')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildPaymentReminder(viewModel.cart!),
              buildStoreDetails(viewModel),
              buildOrderItems(viewModel),
              AddressDetails(viewModel: viewModel),
              buildAddNoteSection(viewModel),
              _buildDeleteButton(viewModel),
              _buildPaymentButton(),
              CancellationButton(),
              _buildBottomBar(viewModel),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(

            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(

              background: const OrderStatus(),

              title: SilverAppBarTitle(controller: _scrollController ),
            ),
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20
                ),
                onPressed: () {  Navigator.of(context).pop();},
              ),
            ),
          ),
          _buildSliverContent(viewModel),
        ],
      ),
    );
  }
  Widget _buildSliverContent(CartPageViewModel viewModel) {
    return SliverList(
      delegate: SliverChildListDelegate([
        buildPaymentReminder(viewModel.cart!),
        buildStoreDetails(viewModel),
        buildOrderItems(viewModel),
        AddressDetails(viewModel: viewModel),
        buildAddNoteSection(viewModel),
        _buildDeleteButton(viewModel),
        _buildPaymentButton(),
        CancellationButton(),
        _buildBottomBar(viewModel),
      ]),
    );
  }

  Widget buildPaymentReminder(Sale cart) {
    if (["not_placed", "delivered", "cancelled", "rejected"].contains(cart.status)) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: Colors.lightBlueAccent, size: 24),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Pay at delivery through Cash/UPI",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.lightBlueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStoreDetails(CartPageViewModel viewModel) {
    if (viewModel.store == null) return const SizedBox();
    Store store = viewModel.store!;
    const Color phoneColor = Color.fromARGB(255, 33, 89, 243);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            store.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          if (store.phone.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.phone, color: phoneColor, size: 20),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => launchUrl(Uri(scheme: 'tel', path: "+91 ${store.phone}")),
                  child: Text(
                    "+91 ${store.phone}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: phoneColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildOrderItems(CartPageViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: viewModel.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CartItem(
                  product: viewModel.products[index],
                  cart: viewModel.cart!,
                  addable: viewModel.notPlaced,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildAddNoteSection(CartPageViewModel viewModel) {
    if (["delivered", "cancelled", "rejected"].contains(viewModel.cart!.status)) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Note',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            minLines: 3,
            maxLines: 5,
            controller: viewModel.noteController,
            decoration: InputDecoration(
              hintText: 'Add a note to your order',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => viewModel.updateNote(viewModel.noteController.text),
            child: const Text(
              "Save Note",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(CartPageViewModel viewModel) {
    if (viewModel.cart?.status != "not_placed") return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () => _confirmDelete(viewModel),
          icon: const Icon(Icons.delete),
          label: const Text("Delete Cart"),
        ),
      ],
    );
  }

  void _confirmDelete(CartPageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Cart"),
        content: const Text("Are you sure you want to delete this cart?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Provider.of<SalesProvider>(context, listen: false).deleteSale(viewModel.cart!.id);
              context.go("/");
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: () async {
        await PhonePePaymentService().startTransaction(
          context: context,
          mobileNumber: "+919679689833",
          amount: 20.0,
        );
      },
      child: const Text("Pay now"),
    );
  }

  Widget _buildBottomBar(CartPageViewModel viewModel) {
    if (viewModel.cart?.status != "not_placed") return const SizedBox();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt),
              const SizedBox(width: 12),
              const Text("Total Bill   "),
              Text("₹${viewModel.cart!.totalAmount + (viewModel.store?.deliveryCharge ?? 0)}"),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (viewModel.phone.isEmpty || viewModel.address.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your phone number and address')),
                );
                return;
              }
              _askForOrderConfirmation(viewModel);
            },
            child: const Row(
              children: [Text('Place Order'), SizedBox(width: 10), Icon(Icons.arrow_forward)],
            ),
          ),
        ],
      ),
    );
  }

  void _askForOrderConfirmation(CartPageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context2) => AlertDialog(
        title: const Text('Order Confirmation'),
        content: const Text('Are you sure you want to place this order?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context2), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              viewModel.updateCartStatus('placed');
              Navigator.pop(context2);
              Navigator.push(context, MaterialPageRoute(builder: (_) =>  SuccessPage()));
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class SilverAppBarTitle extends StatefulWidget {
  final ScrollController controller;

  const SilverAppBarTitle({super.key, required this.controller});

  @override
  State<SilverAppBarTitle> createState() => _SilverAppBarTitleState();
}

class _SilverAppBarTitleState extends State<SilverAppBarTitle> {
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final bool shouldCollapse = widget.controller.offset > (250 - kToolbarHeight);
    if (shouldCollapse != isCollapsed) {
      setState(() {
        isCollapsed = shouldCollapse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isCollapsed ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 100),
      child: const Text(
        "Order Details",
        style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold),
      ),
    );
  }
}
