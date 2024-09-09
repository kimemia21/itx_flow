
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/paralellogram.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:itx/fromWakulima/widgets/CartPage.dart';
import 'package:itx/fromWakulima/widgets/Search.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

class DetailView extends StatefulWidget {
  final Map champion;

  const DetailView({required this.champion});

  @override
  _DetailViewState createState() => _DetailViewState(champion: champion);
}

class _DetailViewState extends State<DetailView> with TickerProviderStateMixin {
  final Map champion;

  _DetailViewState({required this.champion});

  bool init = false;

  late Animation<double> animation;
  late AnimationController controller;
  final SwiperController _swiperController = SwiperController();

  Widget appBarIcons({required Icon icon}) {
    return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.circular(15)),
        child: icon);
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    Tween<double> tween = Tween(begin: 0.0, end: 400.0);

    animation = tween
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInExpo))
      ..addListener(() {
        setState(() {});
      });

    controller.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        init = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "-----------------------------------------------${champion["imageUrl"]}");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2),
            width: AppWidth(context, 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: appBarIcons(
                    icon: Icon(CupertinoIcons.search),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cartpage()));
                  },
                  child: badges.Badge(
                    showBadge:
                        context.watch<CurrentUserProvider>().cartNumber > 0,
                    badgeContent: Text(
                        "${context.watch<CurrentUserProvider>().cartNumber}"),
                    child: appBarIcons(
                      icon: Icon(CupertinoIcons.shopping_cart),
                    ),
                  ),
                ),
                appBarIcons(
                  icon: Icon(CupertinoIcons.ellipsis_vertical),
                ),
              ],
            ),
          )
        ],
        title: Text(
          "Item",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: backgoundColor,
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: LayoutBuilder(builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;

              return Stack(children: [
                Column(
                  children: [
                    AnimatedOpacity(
                      opacity: init ? 1 : 0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: AppWidth(context, 0.8),
                        height: maxWidth,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              imageOpacity.withOpacity(0.0),
                              imageOpacity.withOpacity(0.0),
                              imageOpacity.withOpacity(0.0),
                              imageOpacity.withOpacity(0.0),
                              // imageOpacity,
                            ],
                          ),
                        ),
                        child: SizedBox(
                          height: AppHeight(context, 0.25),
                          width: AppWidth(context, 0.8),
                          child: Hero(
                            tag: champion["name"].toUpperCase(),
                            child: Swiper(
                              itemBuilder: (context, index) {
                                return Image.network(
                                  // width: AppWidth(context, 0.8),
                                  champion["imageUrl"][index],
                                  fit: BoxFit.cover,
                                );
                              },
                              autoplay: true,
                              itemCount: champion["imageUrl"].length,
                              pagination: SwiperPagination(
                                margin: EdgeInsets.zero,
                                builder: SwiperPagination.dots,
                              ),
                              control:
                                  const SwiperControl(color: Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: init ? 1 : 0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            champion["name"].toLowerCase(),
                            style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.w600)
                                .copyWith(
                                    letterSpacing: 4 +
                                        25 * ((400 - animation.value) / 400.0)),
                          )),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kshs  1200 per bag",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Text("Est.delivery",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              Text(" Fri,12 jul - Mon,15 jul",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Text("Quaility",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Grade one",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              Icon(
                                Icons.check_box,
                                color: Colors.green,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text("Description",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text(champion["description"],
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Define your onTap action here
                      },
                      borderRadius: BorderRadius.circular(
                          20), // Ensure the splash effect matches the border radius
                      child: Container(
                        width: AppWidth(context, 0.85),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue[400],
                        ),
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Buy it now",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: const Color.fromARGB(255, 0, 81, 147),
                      radius: 20,
                      onTap: () {
                        context.read<CurrentUserProvider>().changeCartCount();
                      },
                      borderRadius: BorderRadius.circular(
                          20), // Ensure the splash effect matches the border radius
                      child: Container(
                        width: AppWidth(context, 0.85),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 81, 147),
                            )),
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Add to Cart",
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 0, 81, 147),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Stack(
                //     children: [
                //       Container(
                //           padding:
                //               EdgeInsets.only(left: 15, right: 15, bottom: 20),
                //           width: double.infinity,
                //           height: MediaQuery.of(context).size.height * 0.4,
                //           child: Stack(
                //             children: [
                //               AnimatedBorder(animation: animation),
                //               Align(
                //                 alignment: Alignment.center,
                //                 child: AnimatedOpacity(
                //                   opacity: init ? 1 : 0,
                //                   duration: Duration(milliseconds: 500),
                //                   child: Padding(
                //                     padding: const EdgeInsets.only(top: 50.0),
                //                     child: Column(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceEvenly,
                //                             children: <Widget>[
                //                               Column(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   children: [
                //                                     // Image.asset(
                //                                     //     "images/role/${champion["role.toString().split(".")[1].toLowerCase()}.png",
                //                                     //     width: 40,
                //                                     //     height: 40),
                //                                     SizedBox(
                //                                       height: 20,
                //                                     ),
                //                                     Text("Quality",
                //                                         style: textTheme
                //                                             .titleSmall),
                //                                     Text(champion["quality"],
                //                                         // .toString()
                //                                         // .split(".")[1],
                //                                         style: textTheme
                //                                             .titleSmall
                //                                             ?.copyWith(
                //                                                 color: Color(
                //                                                     0xffAE914B)))
                //                                   ]),
                //                               Column(
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment.center,
                //                                 children: <Widget>[
                //                                   // Container(
                //                                   //   height: 40,
                //                                   //   child: Center(
                //                                   //     child: DifficultyGraph(
                //                                   //         count: widget
                //                                   //             .champion),
                //                                   //   ),
                //                                   // ),
                //                                   SizedBox(
                //                                     height: 20,
                //                                   ),
                //                                   Text(
                //                                     "DIFFICULTY",
                //                                     style: textTheme.titleSmall,
                //                                   ),
                //                                   // Text(
                //                                   //     champion["difficulty"]
                //                                   //         .toString()
                //                                   //         .split(".")[1]
                //                                   //         .toUpperCase(),
                //                                   //     style: textTheme
                //                                   //         .titleSmall
                //                                   //         ?.copyWith(
                //                                   //             color: Color(
                //                                   //                 0xffAE914B)))
                //                                 ],
                //                               )
                //                             ],
                //                           ),
                //                           Padding(
                //                             padding: const EdgeInsets.symmetric(
                //                                 horizontal: 30.0),
                //                             child: Divider(
                //                               color: Colors.white,
                //                               height: 1,
                //                             ),
                //                           ),
                //                           Padding(
                //                             padding: const EdgeInsets.only(
                //                                 left: 20,
                //                                 right: 20,
                //                                 bottom: 30),
                //                             child: Text(champion["description"],
                //                                 style: textTheme.bodyLarge,
                //                                 maxLines: 6,
                //                                 overflow:
                //                                     TextOverflow.ellipsis),
                //                           )
                //                         ]),
                //                   ),
                //                 ),
                //               )
                //             ],
                //           )),
                //     ],
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: AnimatedOpacity(
                //     duration: Duration(milliseconds: 500),
                //     opacity: init ? 1.0 : 0.0,
                //     child: Container(
                //       margin: EdgeInsets.only(bottom: 185),
                //       width: double.infinity,
                //       height: 270,
                //       child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text(
                //               champion["deliveryDate"],
                //               style: textTheme.titleMedium,
                //             ),
                //             SizedBox(
                //               height: 10,
                //             ),
                //             Text(
                //               champion["name"].toUpperCase(),
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .titleLarge
                //                   ?.copyWith(
                //                       letterSpacing: 4 +
                //                           25 *
                //                               ((400 - animation.value) /
                //                                   400.0)),
                //             ),
                //           ]),
                //     ),
                //   ),
                // ),
              ]);
            }),
          ),
          // Padding(
          //     padding: EdgeInsets.only(left: 25, top: 25),
          //     child: CustomBackButton()),
        ],
      ),
    );
  }
}

class DifficultyGraph extends StatelessWidget {
  final count;
  const DifficultyGraph({this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Parallelogram(
        cutLength: 10.0,
        child: Container(
          color: difficultyEnableColor,
          width: 25.0,
          height: 10.0,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 16),
        child: Parallelogram(
          cutLength: 10.0,
          child: Container(
            color: count > 0 ? difficultyEnableColor : difficultyDisableColor,
            width: 25.0,
            height: 10.0,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 32),
        child: Parallelogram(
          cutLength: 10.0,
          child: Container(
            color: count > 1 ? difficultyEnableColor : difficultyDisableColor,
            width: 25.0,
            height: 10.0,
          ),
        ),
      ),
    ]);
  }
}

class AnimatedBorder extends StatelessWidget {
  const AnimatedBorder({
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: MyPainter(value: animation.value),
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          );
        },
      );
    });
  }
}

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[300]?.withOpacity(0.3), shape: BoxShape.circle),
      child: InkWell(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double value;

  MyPainter({required this.value});

  final paintBorder = Paint()
    ..color = Colors.white30
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final transparentBorder = Paint()
    ..color = Colors.transparent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    if (value < 15) {
      double lineValue = size.width * value / 100;
      path.lineTo(lineValue, 0);
      canvas.drawPath(path, paintBorder);
      return;
    } else {
      path.lineTo(size.width * 15 / 100, 0);
      canvas.drawPath(path, paintBorder);
    }

    path = Path();
    path.moveTo(size.width * 15 / 100, 0);

    if (value >= 15 && value <= 85) {
      double lineValue = size.width * value / 100;
      path.lineTo(lineValue, 0);
      canvas.drawPath(path, transparentBorder);
      return;
    } else {
      path.lineTo(size.width * 85 / 100, 0);
      canvas.drawPath(path, transparentBorder);
    }

    path = Path();
    path.moveTo(size.width * 85 / 100, 0);

    if (value > 85 && value < 100) {
      double lineValue = size.width * value / 100;
      path.lineTo(lineValue, 0);
      canvas.drawPath(path, paintBorder);
      return;
    } else {
      path.lineTo(size.width, 0);
      canvas.drawPath(path, paintBorder);
    }

    if (value < 200) {
      double lineValue = size.height * (value - 100) / 100;
      path.lineTo(size.width, lineValue);
      canvas.drawPath(path, paintBorder);
      return;
    } else {
      path.lineTo(size.width, size.height);
      canvas.drawPath(path, paintBorder);
    }

    path = Path();
    path.moveTo(size.width, size.height);

    if (value < 300) {
      double lineValue = size.width - size.width * (value - 200) / 100;
      path.lineTo(lineValue, size.height);
      canvas.drawPath(path, paintBorder);
      return;
    } else {
      path.lineTo(0, size.height);
      canvas.drawPath(path, paintBorder);
    }

    path = Path();
    path.moveTo(0, size.height);

    if (value < 400) {
      double lineValue = size.height - size.height * (value - 300) / 100;
      path.lineTo(0, lineValue);
      canvas.drawPath(path, paintBorder);
      return;
    } else {
      path.lineTo(0, 0);
      canvas.drawPath(path, paintBorder);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
