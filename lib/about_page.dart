import 'package:flutter/material.dart';
import 'package:ToxiCrab/main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1E1E1E), const Color(0xFF1E1E1E)]
              : [Colors.white, const Color(0xFFFFF8E7)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              'assets/images/back.png',
              width: 32,
              height: 32,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: IconButton(
                onPressed: () => MyApp.of(context).toggleTheme(),
                icon: Image.asset(
                  MyApp.of(context).themeMode == ThemeMode.light
                      ? 'assets/images/night-mode.png'
                      : 'assets/images/light-mode.png',
                  width: 27,
                  height: 27,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/LOGO OFFICIAL.png',
                      width: 90,
                      height: 90,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'ToxiCrab',
                      style: TextStyle(
                        fontFamily: 'HindVadodara',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Don\'t Guess the Crab — Know It.',
                      style: TextStyle(
                        fontFamily: 'HindVadodara',
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // WHAT IS TOXICRAB SECTION
              _SectionCard(
                isDark: isDark,
                title: 'What is ToxiCrab?',
                child: _buildRichText(
                  'Did you know that not all crabs are safe to eat? Some are naturally toxic and may cause serious illness or even death if consumed, regardless of preparation or cooking methods. ToxiCrab is an AI-powered image detection system designed to identify and classify crab species, with the aim of raising awareness about the risks associated with the misidentification of toxic crabs.',
                  baseStyle: const TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 13,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 16),

              // THE SPECIES SECTION
              _SectionCard(
                isDark: isDark,
                title: 'The Species',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRichText(
                      'ToxiCrab covers 19 crab species in total, including 5 toxic and 14 non-toxic species.',
                      baseStyle: const TextStyle(
                        fontFamily: 'InclusiveSans',
                        fontSize: 13,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 14),
                    _SpeciesExpandable(
                      isDark: isDark,
                      label: '5 Toxic Species',
                      isToxic: true,
                      description:
                          'The five toxic species are classified as permanently highly toxic, meaning they are naturally poisonous at all times and have been associated with fatal poisoning cases. All five species belong to the family Xanthidae. This classification is based on the Food and Agriculture Organization (FAO) Species Identification Guide.',
                      species: const [
                        _SpeciesData('Curry Puff / Crested Reef Crab', 'Platypodia granulosa', 'assets/images/Curry_TOXIC.png'),
                        _SpeciesData('Demon Crab', 'Demania sp.', 'assets/images/Demon_TOXIC.png'),
                        _SpeciesData('Devil / Jewel Crab', 'Zosimus aeneus', 'assets/images/Devil_TOXIC.png'),
                        _SpeciesData('Floral / Green Egg Crab', 'Atergatis floridus', 'assets/images/Floral_TOXIC.png'),
                        _SpeciesData('Mosaic Reef Crab', 'Lophozozymus pictor', 'assets/images/Mosaic_TOXIC.png'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _SpeciesExpandable(
                      isDark: isDark,
                      label: '14 Non-Toxic Species',
                      isToxic: false,
                      description:
                          'The 14 non-toxic species are documented edible crabs referenced from the Field Guide for the Edible Crustacea of the Philippines.',
                      species: const [
                        _SpeciesData('Sentinel Crab', 'Podophthalmus vigil', 'assets/images/12sentinel_NON.png'),
                        _SpeciesData('Blue Swimming Crab', 'Portunus pelagicus', 'assets/images/1blue_NON.png'),
                        _SpeciesData('Mud / Mangrove Crab', 'Scylla serrata', 'assets/images/9mud_NON.png'),
                        _SpeciesData('Coconut Crab', 'Birgus latro', 'assets/images/3coconut_NON.png'),
                        _SpeciesData('Curacha', 'Ranina ranina', 'assets/images/6curacha_NON.png'),
                        _SpeciesData('Moon Crab', 'Matuta lunaris', 'assets/images/8moon_NON.png'),
                        _SpeciesData('Three-Spot Swimming Crab', 'Portunus sanguinolentus', 'assets/images/14three_NON.png'),
                        _SpeciesData('Coral Crab', 'Charybdis feriata', 'assets/images/4coral_NON.png'),
                        _SpeciesData('Ridged Swimming Crab', 'Charybdis natator', 'assets/images/10ridged_NON.png'),
                        _SpeciesData('Crenate / Swimming Crab', 'Thalamita crenata', 'assets/images/5crenate_NON.png'),
                        _SpeciesData('Horned Ghost Crab', 'Ocypode ceratophthalmus', 'assets/images/7horned_NON.png'),
                        _SpeciesData('Smooth-Eyed Ghost Crab', 'Ocypode cordimana', 'assets/images/13smooth_NON.png'),
                        _SpeciesData('River Swimming Crab', 'Varuna litterata', 'assets/images/11river_NON.png'),
                        _SpeciesData('Brown Land Crab', 'Cardisoma carnifex', 'assets/images/2brown_NON.png'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // WHY IT MATTERS SECTION
              _SectionCard(
                isDark: isDark,
                title: 'Why It Matters',
                child: _buildRichText(
                  'Fishers, seafood vendors, consumers, and the general public may not always be able to distinguish toxic crabs from edible species. ToxiCrab aims to bridge this gap by providing an accessible tool for visual screening and public awareness, helping users make safer and more informed decisions.',
                  baseStyle: const TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 13,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 16),

              // HOW TO USE SECTION
              _SectionCard(
                isDark: isDark,
                title: 'How to Use It',
                child: _buildRichText(
                  'Simply capture or upload a clear image of an uncooked crab. Ensure that the photo shows the dorsal (top) view of the crab and not the ventral (belly) side. ToxiCrab will then analyze the image and provide the corresponding species classification result.',
                  baseStyle: const TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 13,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 16),

              // DISCLAIMER SECTION
              _SectionCard(
                isDark: isDark,
                title: 'Disclaimer',
                accentColor: Colors.red,
                titleIcon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                child: _buildRichText(
                  'ToxiCrab is intended as a visual screening and public awareness tool to support safety and education. It is not a substitute for professional or expert species identification. In cases of uncertainty, users are strongly advised to consult a qualified expert before consuming any unfamiliar crab species.',
                  baseStyle: TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 16),

              // AUTHORS SECTION
              _AuthorsExpandable(isDark: isDark),

              const SizedBox(height: 30),

              // FOOTER
              Center(
                child: Text(
                  '© 2026 ToxiCrab. All Rights Reserved.',
                  style: TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.4),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Species data model ───────────────────────────────────────────────────────

class _SpeciesData {
  final String commonName;
  final String scientificName;
  final String imagePath;

  const _SpeciesData(this.commonName, this.scientificName, this.imagePath);
}

// ─── Collapsible species expandable widget ────────────────────────────────────

class _SpeciesExpandable extends StatefulWidget {
  final bool isDark;
  final String label;
  final bool isToxic;
  final String description;
  final List<_SpeciesData> species;

  const _SpeciesExpandable({
    required this.isDark,
    required this.label,
    required this.isToxic,
    required this.description,
    required this.species,
  });

  @override
  State<_SpeciesExpandable> createState() => _SpeciesExpandableState();
}

class _SpeciesExpandableState extends State<_SpeciesExpandable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final Color accentColor =
        widget.isToxic ? const Color(0xFFE53935) : const Color(0xFF43A047);
    final Color bgColor = widget.isToxic
        ? (widget.isDark
            ? const Color(0xFF2E2424)
            : const Color(0xFFFFF0F0))
        : (widget.isDark
            ? const Color(0xFF222E22)
            : const Color(0xFFF0FFF2));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header tap row ──
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    widget.isToxic
                        ? Icons.dangerous_rounded
                        : Icons.check_circle_rounded,
                    color: accentColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'HindVadodara',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: accentColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded content ──
          if (_expanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
              child: Text(
                widget.description,
                style: TextStyle(
                  fontFamily: 'InclusiveSans',
                  fontSize: 12,
                  height: 1.6,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: widget.species
                    .map((s) => _SpeciesCard(
                          data: s,
                          isDark: widget.isDark,
                          isToxic: widget.isToxic,
                          accentColor: accentColor,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Individual species card ──────────────────────────────────────────────────

class _SpeciesCard extends StatelessWidget {
  final _SpeciesData data;
  final bool isDark;
  final bool isToxic;
  final Color accentColor;

  const _SpeciesCard({
    required this.data,
    required this.isDark,
    required this.isToxic,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.25)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Image or placeholder (shifted right with left padding)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: data.imagePath.isNotEmpty
                  ? Image.asset(
                      data.imagePath,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: accentColor.withOpacity(0.12),
                      child: Icon(
                        Icons.image_outlined,
                        color: accentColor.withOpacity(0.4),
                        size: 28,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Names
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.commonName,
                    style: TextStyle(
                      fontFamily: 'HindVadodara',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data.scientificName,
                    style: TextStyle(
                      fontFamily: 'InclusiveSans',
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Rich text helper ─────────────────────────────────────────────────────────

/// Splits [text] on every occurrence of "ToxiCrab" and renders
/// the keyword in bold while the rest uses [baseStyle].
Widget _buildRichText(
  String text, {
  required TextStyle baseStyle,
  TextAlign textAlign = TextAlign.start,
}) {
  const keyword = 'ToxiCrab';
  final parts = text.split(keyword);
  final spans = <TextSpan>[];

  for (int i = 0; i < parts.length; i++) {
    if (parts[i].isNotEmpty) {
      spans.add(TextSpan(text: parts[i]));
    }
    if (i < parts.length - 1) {
      spans.add(
        TextSpan(
          text: keyword,
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  return Text.rich(
    TextSpan(children: spans),
    style: baseStyle,
    textAlign: textAlign,
  );
}

// ─── Reusable section card widget ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final Widget child;
  final Color? accentColor;
  final Icon? titleIcon;

  const _SectionCard({
    required this.isDark,
    required this.title,
    required this.child,
    this.accentColor,
    this.titleIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? const Color(0xFFFDB850);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2C2C2C)
            : const Color(0xFFFFF6E3),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: accent, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (titleIcon != null) ...[
                titleIcon!,
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'HindVadodara',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: accent == Colors.red ? Colors.red : accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ─── Collapsible authors widget ───────────────────────────────────────────────

class _AuthorsExpandable extends StatefulWidget {
  final bool isDark;

  const _AuthorsExpandable({required this.isDark});

  @override
  State<_AuthorsExpandable> createState() => _AuthorsExpandableState();
}

class _AuthorsExpandableState extends State<_AuthorsExpandable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFFFDB850);
    final Color bgColor = widget.isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFFFF6E3);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: accent, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Authors',
                      style: TextStyle(
                        fontFamily: 'HindVadodara',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: accent,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: accent,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(child: _AuthorCard(imagePath: 'assets/images/1.png', name: 'Desiree Joice F. Boo', isDark: widget.isDark)),
                      Flexible(child: _AuthorCard(imagePath: 'assets/images/3.png', name: 'Rojelyn Laguinan', isDark: widget.isDark)),
                      Flexible(child: _AuthorCard(imagePath: 'assets/images/2.png', name: 'Remart S. Maynantay', isDark: widget.isDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AuthorCard(
                        imagePath: 'assets/images/4.png',
                        name: 'Maureen M. Villamor, Ph.D',
                        isDark: widget.isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class _AuthorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final bool isDark;

  const _AuthorCard({
    required this.imagePath,
    required this.name,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'InclusiveSans',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}