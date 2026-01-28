import 'package:flutter/material.dart';
import 'package:github_inspection/api_calls/modal_responses.dart';
import 'package:github_inspection/components/appbar.dart';
import 'package:github_inspection/components/dialogs.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getIpAddress(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final deviceWidth = media.size.width;
    final deviceHeight = media.size.height;
    final isPortrait = media.orientation == Orientation.portrait;
    bool entered;

    // Responsive values
    double horizontalPadding = deviceWidth * 0.04;
    double verticalPadding = deviceHeight * 0.02;
    double imageHeight = isPortrait ? deviceHeight * 0.28 : deviceHeight * 0.45;

    final List<_HomeCardData> cards = [
      _HomeCardData(
        icon: Icons.account_balance,
        label: "First Inspection",
        onTap: () async {
          entered = await showExitDialog(
            context,
            "Do you really want to do first inspection?",
          );
          try {
            if (entered) {
              Navigator.pushNamed(
                // ignore: use_build_context_synchronously
                context,
                "/fi",
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        cardColor: Theme.of(context).colorScheme.surface,
      ),
      _HomeCardData(
        icon: Icons.card_giftcard,
        label: "Second Inspection",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You Clicked Second Inspection")),
          );
        },
        cardColor: Theme.of(context).colorScheme.surface,
      ),
      _HomeCardData(
        icon: Icons.grain,
        label: "Third Inspection",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You Clicked Third Inspection")),
          );
        },
        cardColor: Theme.of(context).colorScheme.surface,
      ),
      _HomeCardData(
        icon: Icons.people_outline,
        label: "Others",
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("You Clicked Others")));
        },
        cardColor: Theme.of(context).colorScheme.surface,
      ),
      _HomeCardData(
        icon: Icons.store_sharp,
        cardColor: Theme.of(context).colorScheme.surface,
        label: "Amenities",
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("You Clicked Amenities")));
        },
      ),
      _HomeCardData(
        icon: Icons.done_all_sharp,
        label: "Done",
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("You Clicked Done")));
        },
        cardColor: Color(0xff57B4BA),
      ),
    ];

    return Scaffold(
      appBar: AppbarWidget(str: "Home"),
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: ShimmerImageExample(requiredimageHeight: imageHeight),
                ),
                SizedBox(height: deviceHeight * 0.03),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isPortrait ? 2 : 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: isPortrait ? 0.95 : 1.1,
                  ),
                  itemBuilder: (context, index) {
                    return _HomeCard(
                      data: cards[index],
                      iconSize: isPortrait
                          ? deviceWidth * 0.12
                          : deviceHeight * 0.10,
                      fontSize: isPortrait
                          ? deviceWidth * 0.035
                          : deviceWidth * 0.015,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final _HomeCardData data;
  final double iconSize;
  final double fontSize;

  const _HomeCard({
    required this.data,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Card(
        elevation: 5,
        color: data.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                size: iconSize,
                shadows: [
                  Shadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    offset: const Offset(3, 3),
                    blurRadius: 10,
                  ),
                ],
              ),
              SizedBox(height: 18),
              Text(
                data.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      offset: const Offset(3, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCardData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? cardColor;
  _HomeCardData({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cardColor,
  });
}

class ShimmerImageExample extends StatefulWidget {
  final double requiredimageHeight;

  const ShimmerImageExample({super.key, required this.requiredimageHeight});

  @override
  State<ShimmerImageExample> createState() => _ShimmerImageExampleState();
}

class _ShimmerImageExampleState extends State<ShimmerImageExample> {
  late Future<void> _imageLoadingFuture;

  @override
  void initState() {
    super.initState();
    _imageLoadingFuture = _precacheImageAsset();
  }

  Future<void> _precacheImageAsset() async {
    await Future.delayed(const Duration(milliseconds: 800));
    await precacheImage(
      const AssetImage('assets/farm.jpg'),
      // ignore: use_build_context_synchronously
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imageLoadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: widget.requiredimageHeight,
              color: Colors.white,
            ),
          );
        } else {
          return Image.asset(
            'assets/farm.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: widget.requiredimageHeight,
          );
        }
      },
    );
  }
}
