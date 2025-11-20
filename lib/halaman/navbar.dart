import 'package:flutter/material.dart';
import 'package:fokusku/halaman/akun.dart';
import 'package:fokusku/halaman/home.dart';
import 'package:fokusku/halaman/koleksi.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Navbar extends StatefulWidget {
   const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
 
  int _currentIndex = 0;

  final List<Widget> halaman = const [Home(),Koleksi(),Akun()];

  final Color selectedItemColor = Color(0xff316E33);
  final Color unselectedItemColor = Color(0xffA5A8A5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: halaman,
      ),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          border: Border.all(color: Color(0xffACCD3D)),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
  //       child:Theme(  data: Theme.of(context).copyWith(
  //   splashColor: Colors.transparent,
  //   highlightColor: Colors.transparent,
  //   splashFactory: NoSplash.splashFactory,
  // ),
  child: 
  BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {setState(() {
          _currentIndex = index;
        });},
        selectedItemColor: Color(0xff316E33),
        unselectedItemColor: Color(0xffA5A8A5),
        items:  [
          BottomNavigationBarItem(icon: 
          SvgPicture.asset(
          "assets/icons/home.svg",
          colorFilter:ColorFilter.mode(
            _currentIndex == 0 ? selectedItemColor : unselectedItemColor,
            BlendMode.srcIn
          ) ,
      
      
          height: 33,
          width: 33,
          ),
           label: 'Home'),
          BottomNavigationBarItem(icon:
           SvgPicture.asset(
          "assets/icons/koleksi.svg",
          colorFilter:ColorFilter.mode(
           _currentIndex == 1 ? selectedItemColor : unselectedItemColor,
            BlendMode.srcIn
          ) ,
          height: 33,
          width: 33,
          ), 
           label: 'Koleksi'),
          BottomNavigationBarItem(icon:
         SvgPicture.asset(
          "assets/icons/akun.svg",
          colorFilter:ColorFilter.mode(
            _currentIndex == 2 ? selectedItemColor : unselectedItemColor,
            BlendMode.srcIn
          ) ,
          height: 28,
          width: 28,
          ),
            label: 'Akun'),
        ],
      ),
      ),
  
   );
  }
}
