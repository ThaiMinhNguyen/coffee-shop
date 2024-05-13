import 'package:coffee_shop/entity/bill.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../entity/item.dart';
import '../services/auth.dart';
import 'package:coffee_shop/services/database.dart';

class BillItem extends StatefulWidget {

  late Bill bill;
  final VoidCallback onSetState;

  BillItem({required this.bill, required this.onSetState});

  @override
  State<BillItem> createState() => _BillItemState();
}

class _BillItemState extends State<BillItem> {

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: Container(
        padding: const EdgeInsets.only(left: 9, right: 15, top: 9, bottom: 9),
        margin: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey,
              Colors.grey,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Name",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.bill.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Price",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  (widget.bill.total).toString() + '\$',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Date",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.bill.date,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                await DatabaseService(uid: _auth.getFireBaseUser()!.uid).deleteBill(widget.bill);
                widget.onSetState();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              )
            )

          ],
        ),
      ),
    );
  }
}
