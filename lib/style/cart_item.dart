import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../entity/item.dart';
import '../services/auth.dart';
import 'package:coffee_shop/services/database.dart';

class CartItem extends StatefulWidget {

  late Item item;
  final VoidCallback onSetState;

  CartItem({required this.item, required this.onSetState});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

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
              Colors.black45,
              Colors.blueAccent,
            ],
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.item.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () async {
                          setState(() {
                            if(widget.item.quantity > 0){
                              widget.item.quantity -= 1;
                            }
                          });
                          await DatabaseService(uid: _auth.getFireBaseUser()!.uid).updateQuantity(_auth.getFireBaseUser()!.uid, widget.item.name, widget.item.quantity);
                          await DatabaseService(uid: _auth.getFireBaseUser()!.uid).removeItemsWithZeroQuantityFromCart(_auth.getFireBaseUser()!.uid);
                          widget.onSetState();
                        },
                      ),
                      Text(
                        (widget.item.quantity).toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          setState(() {
                            if(widget.item.quantity < 100){
                              widget.item.quantity += 1;
                            }
                          });
                          await DatabaseService(uid: _auth.getFireBaseUser()!.uid).updateQuantity(_auth.getFireBaseUser()!.uid, widget.item.name, widget.item.quantity);
                          widget.onSetState();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
