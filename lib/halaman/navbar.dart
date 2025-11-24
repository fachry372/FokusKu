import 'package:flutter/material.dart';
import 'package:fokusku/halaman/akun.dart';
import 'package:fokusku/halaman/home.dart';
import 'package:fokusku/halaman/koleksi.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final List<Widget> halaman = const [Home(), Koleksi(), Akun()];

  final Color selectedColor = Color(0xff316E33);
  final Color unselectedColor = Color(0xffA5A8A5);

   String _getlabel(int index) {
            switch (index) {
              case 0:
              return "Home";
              case 1:
              return "Koleksi";
              case 2:
              return "Akun";
              default:
              return "";
            }
           }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEFD9),

      body: IndexedStack(index: _currentIndex, children: halaman),
      bottomNavigationBar: Container(
        
        
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(color: Color(0xffACCD3D)),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem("assets/icons/home.svg",0,33),
            _navItem("assets/icons/koleksi.svg", 1, 33),
            _navItem("assets/icons/akun.svg", 2, 32),
          ]

          
             
        ),
      ),
    );
  }


Widget _navItem(String asset , int index ,double size) {
 bool selected = _currentIndex == index;

 return Material(
color: Colors.transparent,
 child: InkResponse(
 onTap: () {
 setState(() {
 _currentIndex = index;
 });
 },
        
 radius: 70, 
 containedInkWell: true, 
 highlightShape: BoxShape.circle, 
borderRadius: BorderRadius.circular(10),
splashColor: Color.fromARGB(255, 201, 207, 200),
 child: Container(
  width: 80,
 
 padding: const EdgeInsets.symmetric(vertical: 6, ), 
 child: Column(
mainAxisSize: MainAxisSize.min,
children: [ 
 SvgPicture.asset(
 asset,
 height: size,
 width: size,
 colorFilter: ColorFilter.mode(
 selected ? selectedColor : unselectedColor,
 BlendMode.srcIn,
 ),
),
 const SizedBox(height: 4,),
 Text(
 _getlabel(index),
 style: GoogleFonts.inter(fontSize: 12,
 color: selected ? selectedColor : unselectedColor,
),
),


 ]
 )
 )
 ),
 );
 }
  } 

