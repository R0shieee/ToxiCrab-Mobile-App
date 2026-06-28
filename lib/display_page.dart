import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ToxiCrab/main.dart';

const Map<String, String> crabCommonNames = {
  'zosimus_aeneus': 'Devil Crab | Jewel Crab',
  'atergatis_floridus': 'Floral Egg Crab | Green Egg Crab',
  'platypodia_granulosa': 'Curry Puff Crab | Crested Reef Crab',
  'lophozozymus_pictor': 'Mosaic Reef Crab',
  'demania_sp': 'Demon Crab',
  'podophthalmus_vigil': 'Sentinel Crab',
  'portunus_pelagicus': 'Blue Swimming Crab',
  'scylla_serrata': 'Mud/Mangrove Crab',
  'birgus_latro': 'Coconut Crab',
  'ranina_ranina': 'Curacha',
  'matuta_lunaris': 'Moon Crab',
  'portunus-sanguinolentus': 'Three-Spot Swimming Crab',
  'charybdis_feriata': 'Coral Crab',
  'charybdis_natator': 'Ridged Swimming Crab',
  'thalamita_crenata': 'Crenate/Swimming Crab',
  'ocypode_ceratophthalma': 'Horned Ghost Crab',
  'ocypode_cordimana': 'Smooth-Eyed Ghost Crab',
  'varuna_litterata': 'River Swimming Crab',
  'cardisoma_carnifex': 'Brown Land Crab',
};

// ── Edible & Market Info ─────────────────────────────────────────────────────
const Map<String, String> edibleMarketInfo = {
  'podophthalmus_vigil':
      'Edible but not commonly eaten and rarely available in seafood markets.',
  'portunus_pelagicus':
      'Edible and widely available in local seafood markets and restaurants.',
  'scylla_serrata':
      'Edible and commonly sold in seafood markets, restaurants, and aquaculture farms.',
  'birgus_latro':
      'Edible but rarely available in markets because harvesting is restricted or protected in many regions.',
  'ranina_ranina':
      'Edible and occasionally available in seafood markets, especially in coastal areas.',
  'matuta_lunaris':
      'Edible and sometimes eaten locally, but rarely sold in commercial seafood markets.',
  'portunus-sanguinolentus':
      'Edible and commonly available in coastal seafood markets.',
  'charybdis_feriata':
      'Edible and occasionally sold in seafood markets and restaurants.',
  'charybdis_natator':
      'Edible and sometimes available in local coastal seafood markets.',
  'thalamita_crenata':
      'Edible but usually consumed locally and not commonly found in large seafood markets.',
  'ocypode_ceratophthalma':
      'Edible but rarely eaten and generally not sold in seafood markets.',
  'ocypode_cordimana':
      'Edible and occasionally eaten locally, but not commercially sold in markets.',
  'varuna_litterata':
      'Edible and sometimes sold in small local markets, though not widely commercialized.',
  'cardisoma_carnifex':
      'Edible and occasionally sold in local coastal markets in some tropical regions.',
};

// ── Toxic species extended info ─────────────────────────────────────────────
class _ToxicSpeciesInfo {
  final String description;
  final List<String> toxins;
  final List<String> symptoms;
  final String toxicity;
  final String distribution;

  const _ToxicSpeciesInfo({
    required this.description,
    required this.toxins,
    required this.symptoms,
    required this.toxicity,
    required this.distribution,
  });
}

const Map<String, _ToxicSpeciesInfo> toxicSpeciesInfo = {
  'zosimus_aeneus': _ToxicSpeciesInfo(
    description:
        'A highly poisonous Indo-Pacific crab with a rounded, granular carapace. It has dark reddish-brown to deep orange spots over a pale yellow to white background, making it visually distinctive. Usually found in coral reefs, reef flats, and rocky coastal areas.',
    toxins: ['Tetrodotoxin (TTX)', 'Saxitoxin (SXN)'],
    symptoms: [
      'Numbness (lips, face, fingers)',
      'Dizziness',
      'Vomiting',
      'Muscle paralysis',
      'Respiratory failure (can be fatal)',
    ],
    toxicity: 'Highly poisonous if consumed',
    distribution:
        'Southeast Asia, Indo-Pacific Region, Red Sea, Pacific Ocean',
  ),
  'atergatis_floridus': _ToxicSpeciesInfo(
    description:
        'A medium-sized reef crab with a rounded, slightly convex, granular carapace. It has striking dark reddish-brown to orange patches on a pale yellow or whitish background. Commonly seen in coral reefs, rocky shores, and shallow intertidal zones.',
    toxins: ['Tetrodotoxin (TTX)', 'Saxitoxin (SXN)'],
    symptoms: [
      'Numbness (lips, face, fingers)',
      'Dizziness',
      'Vomiting',
      'Muscle paralysis',
      'Respiratory failure (can be fatal)',
    ],
    toxicity: 'Highly poisonous if consumed',
    distribution: 'Southeast Asia, Tropical Indo-Pacific Region',
  ),
  'platypodia_granulosa': _ToxicSpeciesInfo(
    description:
        'A small to medium crab with a broad, oval carapace and rough, granular surface. Color ranges from brown to reddish-brown, often with mottled patterns for camouflage. Claws are short and stout. Usually inhabits coral reefs and rocky seabeds.',
    toxins: ['Tetrodotoxin (TTX)', 'Saxitoxin (SXN)'],
    symptoms: [
      'Numbness (lips, face, fingers)',
      'Dizziness',
      'Vomiting',
      'Muscle paralysis',
      'Respiratory failure (can be fatal)',
    ],
    toxicity: 'Highly poisonous if consumed',
    distribution:
        'Southeast Asia, Tropical Indo-Pacific Coral Reefs, Pacific Ocean',
  ),
  'demania_sp': _ToxicSpeciesInfo(
    description:
        'Small to medium crabs with a broad, slightly convex carapace. Surface is smooth to finely granular, with brown, reddish, or mottled coloration for camouflage. Claws are sturdy and proportionate. Commonly found hiding among coral reefs and rocky substrates.',
    toxins: ['Tetrodotoxin (TTX)', 'Saxitoxin (SXN)'],
    symptoms: [
      'Numbness (lips, face, fingers)',
      'Dizziness',
      'Vomiting',
      'Muscle paralysis',
      'Respiratory failure (can be fatal)',
    ],
    toxicity: 'Highly poisonous if consumed',
    distribution: 'Southeast Asia, Tropical Indo-Pacific Coral Reefs',
  ),
  'lophozozymus_pictor': _ToxicSpeciesInfo(
    description:
        'A medium-sized reef crab with a broad, convex carapace. It has a smooth to slightly granular surface and vivid mosaic-like coloration of red, orange, white, and dark patches. Claws are thick and similarly patterned. Usually seen in coral reefs and rocky coastal habitats.',
    toxins: ['Tetrodotoxin (TTX)', 'Saxitoxin (SXN)'],
    symptoms: [
      'Numbness (lips, face, fingers)',
      'Dizziness',
      'Vomiting',
      'Muscle paralysis',
      'Respiratory failure (can be fatal)',
    ],
    toxicity: 'Highly poisonous if consumed',
    distribution:
        'Southeast Asia, Tropical Indo-Pacific Coral Reefs, Pacific Ocean',
  ),
};

// ── Non-toxic species extended info ─────────────────────────────────────────
class _NonToxicSpeciesInfo {
  final String description;
  final String distribution;
  final String funFact;

  const _NonToxicSpeciesInfo({
    required this.description,
    required this.distribution,
    required this.funFact,
  });
}

const Map<String, _NonToxicSpeciesInfo> nonToxicSpeciesInfo = {
  'podophthalmus_vigil': _NonToxicSpeciesInfo(
    description:
        'The main characteristic of this crab is the presence of two long eyes, reaching to or extended beyond the edge of its carapace. The carapace is slightly broader than long; where the anterior margin is much broader than posterior margin. Usually found in sandy and muddy coastal areas, estuaries, and shallow waters.',
    distribution:
        'Southeast Asia, Indo-West Pacific, Coastal and Estuarine Regions',
    funFact:
        'It is sometimes called a "looking crab" because its tall eyestalks make it appear like it\'s constantly scanning its surroundings, almost like a guard on watch.',
  ),
  'portunus_pelagicus': _NonToxicSpeciesInfo(
    description:
        'A medium-sized crab with a broad, flattened carapace and long, slender legs adapted for swimming. Males are bright blue with white markings, while females are duller with brownish tones. Commonly found in sandy seabeds, seagrass beds, and shallow coastal waters.',
    distribution: 'Southeast Asia, Indo-West Pacific, South Asia',
    funFact:
        'Unlike many crabs, it is an excellent swimmer — using its paddle-shaped rear legs to move quickly through water, making it one of the most agile crabs in coastal areas.',
  ),
  'scylla_serrata': _NonToxicSpeciesInfo(
    description:
        'A large swimming crab with a broad oval carapace, strong clawed forelegs, and a modified rear pair of legs for swimming. It has spined frontal and side edges on its shell, with noticeable differences between males (narrow abdomen) and females (broader abdomen). Its color varies from green to brown, purple, or black. Usually inhabits mangroves, muddy estuaries, and brackish coastal waters.',
    distribution:
        'Southeast Asia, Indian Ocean, Western Pacific Ocean, Red Sea, New Zealand, Tahiti',
    funFact: 'Can regenerate lost claws over time after injury or escape.',
  ),
  'birgus_latro': _NonToxicSpeciesInfo(
    description:
        'The largest land crab with a heavy body, strong claws, and a hard exoskeleton; colors range from blue to purple or reddish. Commonly found in coastal forests, rocky shores, and tropical islands.',
    distribution:
        'Southeast Asia, Indian Ocean, Pacific Ocean, Pacific Islands',
    funFact:
        'It is the largest terrestrial arthropod and can climb coconut trees to feed on fruits. Anything left unattended on the ground is a potential source of food, which they will investigate and may carry away — thereby getting the alternative name of "robber crab".',
  ),
  'ranina_ranina': _NonToxicSpeciesInfo(
    description:
        'The carapace is wider at the front, reddish brown in color, with ten white spots. Ranina ranina is mainly nocturnal, and remains buried in the sand during the day. Usually found buried in sandy seabeds of shallow coastal waters.',
    distribution:
        'Southeast Asia, Tropical Indo-Pacific waters, East Asia, Pacific Ocean',
    funFact:
        'Also called the "red frog crab" because of its frog-like shape and behavior of hiding beneath sand.',
  ),
  'matuta_lunaris': _NonToxicSpeciesInfo(
    description:
        'It has a finely textured carapace with distinct tubercles and ridges, including six on the dorsal surface and several along the front and sides. The chelipeds show a lobed ridge pattern, with a sex difference where males have an extra ridge on the dactylus that females lack. Its carapace is beige to yellow with red spots. Commonly seen on sandy beaches and shallow coastal seabeds.',
    distribution:
        'Southeast Asia, Indian Ocean, Pacific Ocean, Red Sea, East Africa, South Asia',
    funFact:
        'Known for "sand swimming," using its legs to quickly bury itself when disturbed.',
  ),
  'portunus-sanguinolentus': _NonToxicSpeciesInfo(
    description:
        'Medium-sized swimming crab with a broad shell and three distinct dark spots on its carapace; strong paddle-like rear legs for swimming. Usually found on sandy and muddy coastal bottoms.',
    distribution:
        'Southeast Asia, Indo-West Pacific, Red Sea, East Africa, South Asia, East Asia',
    funFact:
        'Its three spots are a key identifying feature and make it easy to distinguish from other swimming crabs.',
  ),
  'charybdis_feriata': _NonToxicSpeciesInfo(
    description:
        'A fan-shaped swimming crab about 20 cm wide with a smooth, slightly lined carapace and spined claws. It has paddle-like rear legs for swimming and a bold cream-and-brown pattern, often with a distinctive white cross marking on its shell. Commonly inhabits sandy, muddy, and coral reef coastal habitats.',
    distribution:
        'Southeast Asia, Western Indo-Pacific Region, East Africa, Red Sea, Persian Gulf',
    funFact:
        'Also called the "Crucifix crab" because of the cross marking on its carapace.',
  ),
  'charybdis_natator': _NonToxicSpeciesInfo(
    description:
        'A fan-shaped swimming crab with a brown to orange shell, bluish underside, and dark legs. Its carapace has spines, granules, and short hair-like texture, with distinct markings on its claws, including blue spots and black tips. The hind legs are flattened and adapted for multidirectional swimming. Usually found in sandy seabeds, reefs, and shallow coastal waters.',
    distribution:
        'Southeast Asia, Indian Ocean, Western Pacific Ocean, Red Sea, Mascarene Islands',
    funFact:
        'Charybdis natator can swim in any direction using its paddle-like hind legs, making it one of the most agile swimming crabs in coastal waters.',
  ),
  'thalamita_crenata': _NonToxicSpeciesInfo(
    description:
        'Medium-sized swimming crab with a rounded, smooth carapace and five side teeth. It has paddle-like hind legs for swimming and males have a long, slender reproductive appendage. Typically greenish-brown for camouflage in coastal habitats. Commonly found in mangroves, mudflats, and seagrass areas.',
    distribution:
        'Southeast Asia, Indo-West Pacific Mangrove Regions, East Africa, South Asia, East Asia',
    funFact:
        'Unlike many crabs, it is an active hunter rather than just a scavenger.',
  ),
  'ocypode_ceratophthalma': _NonToxicSpeciesInfo(
    description:
        'A small box-shaped crab (6–8 cm wide) that is usually bluish-grey with brown markings, often forming an "H" pattern. It has long downward-pointing claws, long legs, and eyes on short stalks with horn-like extensions in adults. It can burrow into sand with its eyes folding away and is capable of changing its body color and pattern to match its surroundings. Usually found on sandy beaches and coastal dunes.',
    distribution:
        'Southeast Asia, Indo-West Pacific Sandy Beaches, Pacific Islands, South Asia',
    funFact:
        'Ghost crabs can really run fast! As suggested by their scientific name — "Ocy" means swift and "podi" means foot in Greek.',
  ),
  'ocypode_cordimana': _NonToxicSpeciesInfo(
    description:
        'Body width about 5 cm. Body squarish box-like. Pale greyish blue without dark markings on the back of the body. Pincers long, downward pointing. It lacks ridges on the inside of the "palm". Legs long with pointed tips. Large eyes on very short stalks, without "horns" on top of the eye. Commonly seen on sandy shores and beach burrows.',
    distribution:
        'Southeast Asia, Indo-West Pacific Coastal Regions, Pacific Islands',
    funFact:
        'It is a fast, nocturnal crab that can sprint across sand at high speed and quickly disappear into burrows when disturbed, helping it avoid predators.',
  ),
  'varuna_litterata': _NonToxicSpeciesInfo(
    description:
        'Medium-sized crab with a smooth, rounded carapace and long legs adapted for swimming. It has a greenish to brownish coloration and strong paddle-like hind legs. Usually inhabits rivers, estuaries, and mangrove areas.',
    distribution:
        'Southeast Asia, Indo-West Pacific Rivers and Estuaries, South Asia, East Asia',
    funFact:
        'It is one of the few swimming crabs that can live far inland in freshwater rivers, sometimes traveling long distances upstream.',
  ),
  'cardisoma_carnifex': _NonToxicSpeciesInfo(
    description:
        'Carapace is smooth, swollen, and oval-shaped, with small setose (hairy) areas on the sides. It has well-developed mouth appendages, and adult males feature one greatly enlarged claw. The legs lack distinct stiff setae, and its color ranges from brown to brownish grey. Commonly found in coastal forests, mangroves, and muddy or sandy shores.',
    distribution:
        'Southeast Asia, Indo-Pacific Coastal Regions, East Africa, Red Sea, Pacific Islands, Cocos (Keeling) Islands, Line Islands, Tuamotu Archipelago',
    funFact:
        'It is a strong burrower, digging deep tunnels in sandy or muddy ground to stay cool and moist.',
  ),
};

// ── Toxin chips in a permanent row, info panel below the selected one ────────
class _ToxinChipRow extends StatefulWidget {
  final List<String> toxins;
  final Color accent;
  final Color textColor;

  const _ToxinChipRow({
    required this.toxins,
    required this.accent,
    required this.textColor,
  });

  @override
  State<_ToxinChipRow> createState() => _ToxinChipRowState();
}

class _ToxinChipRowState extends State<_ToxinChipRow>
    with SingleTickerProviderStateMixin {
  String? _selected;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  static const Map<String, String> _toxinDescriptions = {
    'Tetrodotoxin (TTX)':
        'A potent neurotoxin that blocks sodium channels in nerve cell membranes, preventing nerve signals from firing. Even a tiny amount can cause paralysis and respiratory failure. There is no antidote.',
    'Saxitoxin (SXN)':
        'A powerful neurotoxin that similarly blocks sodium channels, causing rapid loss of nerve and muscle function. It is one of the most toxic non-protein substances known and has no specific antidote.',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(String toxin) {
    setState(() {
      if (_selected == toxin) {
        _selected = null;
        _controller.reverse();
      } else {
        _selected = toxin;
        _controller.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? description =
        _selected != null ? _toxinDescriptions[_selected!] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.toxins.asMap().entries.map((entry) {
            final String t = entry.value;
            final bool isSelected = _selected == t;
            final bool hasInfo = _toxinDescriptions.containsKey(t);
            return Padding(
              padding: EdgeInsets.only(
                  right: entry.key < widget.toxins.length - 1 ? 6 : 0),
              child: GestureDetector(
                onTap: hasInfo ? () => _onTap(t) : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.accent.withOpacity(0.25)
                        : widget.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.accent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'HindVadodara',
                          fontWeight: FontWeight.w600,
                          color: widget.accent,
                        ),
                      ),
                      if (hasInfo) ...[
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: isSelected ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 220),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: widget.accent.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizeTransition(
          sizeFactor: _expandAnim,
          axisAlignment: -1,
          child: description != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 21, right: 2),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'InclusiveSans',
                      color: widget.textColor.withOpacity(0.75),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Accordion: Scientific Name row is the tap trigger ──────────────────────
class _SpeciesInfoCollapsible extends StatefulWidget {
  final String displaySpecies;
  final _ToxicSpeciesInfo info;
  final Color accent;
  final bool isDark;

  const _SpeciesInfoCollapsible({
    required this.displaySpecies,
    required this.info,
    required this.accent,
    required this.isDark,
  });

  @override
  State<_SpeciesInfoCollapsible> createState() =>
      _SpeciesInfoCollapsibleState();
}

class _SpeciesInfoCollapsibleState extends State<_SpeciesInfoCollapsible>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor =
        Theme.of(context).colorScheme.onBackground.withOpacity(0.45);
    final Color textColor = Theme.of(context).colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.science_outlined, size: 16, color: labelColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scientific Name',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'HindVadodara',
                          color: labelColor,
                        ),
                      ),
                      Text(
                        widget.displaySpecies,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'InclusiveSans',
                          fontStyle: FontStyle.italic,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: widget.accent.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnim,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                _InfoSection(
                  icon: Icons.description_outlined,
                  label: 'Description',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: Text(
                      widget.info.description,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'InclusiveSans',
                        color: textColor.withOpacity(0.85),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
                const SizedBox(height: 12),
                // Toxins
                _InfoSection(
                  icon: Icons.biotech,
                  label: 'Toxins',
                  child: _ToxinChipRow(
                    toxins: widget.info.toxins,
                    accent: widget.accent,
                    textColor: textColor,
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
                const SizedBox(height: 12),
                // Toxicity & Symptoms
                _InfoSection(
                  icon: Icons.dangerous_outlined,
                  label: 'Toxicity & Symptoms',
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.red.withOpacity(0.35), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('☠️', style: TextStyle(fontSize: 35)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Highly Poisonous if Consumed',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'HindVadodara',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'No known home remedies or antidote. Seek emergency medical attention immediately.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'HindVadodara',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red.shade700
                                            .withOpacity(0.85),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.red.withOpacity(0.2)),
                        Container(
                          decoration: BoxDecoration(
                            color: widget.isDark
                                ? const Color(0xFF2C2C2C)
                                : Colors.white.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(9),
                              bottomRight: Radius.circular(9),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Symptoms of Poisoning',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'HindVadodara',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade700.withOpacity(0.6),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...widget.info.symptoms.map((s) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Container(
                                              width: 5,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.6),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              s,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'InclusiveSans',
                                                color:
                                                    textColor.withOpacity(0.85),
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
                const SizedBox(height: 12),
                // Geographic Distribution
                _InfoSection(
                  icon: Icons.public_outlined,
                  label: 'Geographic Distribution',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.info.distribution
                          .split(',')
                          .map((r) => r.trim())
                          .where((r) => r.isNotEmpty)
                          .map((region) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 11,
                                    color: widget.accent.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    region,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'HindVadodara',
                                      fontWeight: FontWeight.w500,
                                      color: textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Non-toxic accordion ──────────────────────────────────────────────────────
class _NonToxicSpeciesInfoCollapsible extends StatefulWidget {
  final String speciesKey; // ← NEW: used to look up edibleMarketInfo
  final String displaySpecies;
  final _NonToxicSpeciesInfo info;
  final Color accent;
  final bool isDark;

  const _NonToxicSpeciesInfoCollapsible({
    required this.speciesKey,
    required this.displaySpecies,
    required this.info,
    required this.accent,
    required this.isDark,
  });

  @override
  State<_NonToxicSpeciesInfoCollapsible> createState() =>
      _NonToxicSpeciesInfoCollapsibleState();
}

class _NonToxicSpeciesInfoCollapsibleState
    extends State<_NonToxicSpeciesInfoCollapsible>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor =
        Theme.of(context).colorScheme.onBackground.withOpacity(0.45);
    final Color textColor = Theme.of(context).colorScheme.onBackground;

    // Look up the edibility text for this species
    final String? marketInfo = edibleMarketInfo[widget.speciesKey];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.science_outlined, size: 16, color: labelColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scientific Name',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'HindVadodara',
                          color: labelColor,
                        ),
                      ),
                      Text(
                        widget.displaySpecies,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'InclusiveSans',
                          fontStyle: FontStyle.italic,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: widget.accent.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnim,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                _InfoSection(
                  icon: Icons.description_outlined,
                  label: 'Description',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: Text(
                      widget.info.description,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'InclusiveSans',
                        color: textColor.withOpacity(0.85),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
                const SizedBox(height: 12),
                // Fun Fact
                _InfoSection(
                  icon: Icons.emoji_objects_rounded,
                  label: 'Fun Fact',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: widget.accent.withOpacity(0.25)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('🦀', style: TextStyle(fontSize: 35)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.info.funFact,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'InclusiveSans',
                              color: textColor.withOpacity(0.85),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
                // ── Edibility & Market Availability ─────────────────────────
                if (marketInfo != null) ...[
                  const SizedBox(height: 12),
                  _InfoSection(
                    icon: Icons.storefront_outlined,
                    label: 'Edibility & Market Availability',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.accent.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: widget.accent.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🍽️', style: TextStyle(fontSize: 25)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              marketInfo,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'InclusiveSans',
                                color: textColor.withOpacity(0.85),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    labelColor: labelColor,
                    accent: widget.accent,
                  ),
                ],
                // ────────────────────────────────────────────────────────────
                const SizedBox(height: 12),
                // Geographic Distribution
                _InfoSection(
                  icon: Icons.public_outlined,
                  label: 'Geographic Distribution',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.info.distribution
                          .split(',')
                          .map((r) => r.trim())
                          .where((r) => r.isNotEmpty)
                          .map((region) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 11,
                                    color: widget.accent.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    region,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'HindVadodara',
                                      fontWeight: FontWeight.w500,
                                      color: textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  labelColor: labelColor,
                  accent: widget.accent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Small helper for a labeled info row ────────────────────────────────────
class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;
  final Color labelColor;
  final Color accent;

  const _InfoSection({
    required this.icon,
    required this.label,
    required this.child,
    required this.labelColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: labelColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'HindVadodara',
                fontWeight: FontWeight.w600,
                color: labelColor,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────

class DisplayPage extends StatefulWidget {
  final Map<String, dynamic> result;
  final String imagePath;

  const DisplayPage({super.key, required this.result, required this.imagePath});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final GlobalKey _captureKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveResult() async {
    setState(() => _isSaving = true);
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) await Gal.requestAccess();

      RenderRepaintBoundary boundary = _captureKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/toxicrab_result_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      await Gal.putImage(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Result saved to gallery!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Widget _buildCombinedCard({
    required bool isToxic,
    required int totalCount,
    required Map<String, List<Map<String, dynamic>>> groupedEntries,
    required bool isDark,
    required BuildContext context,
  }) {
    final Color accent = isToxic ? Colors.red : Colors.green;
    final Color bannerBg = isToxic
        ? (isDark ? const Color(0xFF3A0000) : const Color(0xFFFFEDED))
        : (isDark ? const Color(0xFF003A0F) : const Color(0xFFEDFFED));
    final Color cardBg =
        isDark ? const Color(0xFF2C2C2C) : Colors.white.withOpacity(0.9);

    final String bannerTitle =
        isToxic ? 'Toxic Crab Detected' : 'Non-Toxic Crab Detected';

    final List<String> allConfidences = [];
    for (final entry in groupedEntries.entries) {
      for (final d in entry.value) {
        allConfidences.add('${(d["confidence"] as num).toStringAsFixed(1)}%');
      }
    }
    final String confidenceText = 'Confidence: ${allConfidences.join(' • ')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: bannerBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isToxic
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline_rounded,
                        color: accent,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bannerTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'HindVadodara',
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    confidenceText,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'HindVadodara',
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: accent.withOpacity(0.2)),
            ...groupedEntries.entries.map((entry) {
              final String speciesKey = entry.key;
              final String commonName =
                  crabCommonNames[speciesKey] ?? 'Unknown';
              String displaySpecies = speciesKey.replaceAll('_', ' ');
              displaySpecies = displaySpecies[0].toUpperCase() +
                  displaySpecies.substring(1);

              final _ToxicSpeciesInfo? toxicInfo =
                  isToxic ? toxicSpeciesInfo[speciesKey] : null;
              final _NonToxicSpeciesInfo? nonToxicInfo =
                  !isToxic ? nonToxicSpeciesInfo[speciesKey] : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.label_outline_rounded,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.45)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Common Name',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'HindVadodara',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.45),
                                ),
                              ),
                              Text(
                                commonName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'HindVadodara',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (toxicInfo != null)
                    _SpeciesInfoCollapsible(
                      displaySpecies: displaySpecies,
                      info: toxicInfo,
                      accent: accent,
                      isDark: isDark,
                    )
                  else if (nonToxicInfo != null)
                    _NonToxicSpeciesInfoCollapsible(
                      speciesKey: speciesKey, // ← NEW: passed down here
                      displaySpecies: displaySpecies,
                      info: nonToxicInfo,
                      accent: accent,
                      isDark: isDark,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.science_outlined,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.45)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scientific Name',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'HindVadodara',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.45),
                                  ),
                                ),
                                Text(
                                  displaySpecies,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'InclusiveSans',
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (entry.key != groupedEntries.keys.last)
                    Divider(height: 1, color: accent.withOpacity(0.15)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCrabCard({
    required bool isDark,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF2C2C2C)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3A3A3A)
                    : const Color(0xFFF0F0F0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_off_rounded, color: Colors.grey, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'No Crab Detected',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'HindVadodara',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.45),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No known crab species identified in the image.',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'InclusiveSans',
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool detected = widget.result["detected"] ?? false;
    final List detections =
        List<Map<String, dynamic>>.from(widget.result["detections"] ?? []);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final d in detections) {
      final key = (d["species"] as String).toLowerCase();
      grouped.putIfAbsent(key, () => []).add(Map<String, dynamic>.from(d));
    }

    for (final list in grouped.values) {
      list.sort((a, b) =>
          (b["confidence"] as double).compareTo(a["confidence"] as double));
    }

    final Map<String, List<Map<String, dynamic>>> toxicGroups = {
      for (final e in grouped.entries)
        if (e.value.first["is_toxic"] == true) e.key: e.value,
    };
    final Map<String, List<Map<String, dynamic>>> nonToxicGroups = {
      for (final e in grouped.entries)
        if (e.value.first["is_toxic"] == false) e.key: e.value,
    };

    final int toxicCount =
        detections.where((d) => d["is_toxic"] == true).length;
    final int nonToxicCount =
        detections.where((d) => d["is_toxic"] == false).length;

    double imgW = detections.isNotEmpty
        ? (detections[0]["image_width"] ?? 1).toDouble()
        : 1;
    double imgH = detections.isNotEmpty
        ? (detections[0]["image_height"] ?? 1).toDouble()
        : 1;

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
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              RepaintBoundary(
                key: _captureKey,
                child: Container(
                  color: isDark
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFFFF8E7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Image.asset('assets/images/LOGO OFFICIAL.png',
                                width: 40, height: 40),
                            const SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'HindVadodara',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'ToxiCrab',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        " | Don\u2019t Guess the Crab \u2014 Know It.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Result',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'HindVadodara',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double displayW = constraints.maxWidth;
                                final double displayH = constraints.maxHeight;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(widget.imagePath),
                                      width: displayW,
                                      height: displayH,
                                      fit: BoxFit.cover,
                                    ),
                                    CustomPaint(
                                      painter: MultiBoxPainter(
                                        detections: detections
                                            .map((d) =>
                                                Map<String, dynamic>.from(d))
                                            .toList(),
                                        imageWidth: imgW,
                                        imageHeight: imgH,
                                        displayWidth: displayW,
                                        displayHeight: displayH,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!detected) ...[
                        _buildNoCrabCard(isDark: isDark, context: context),
                        const SizedBox(height: 12),
                      ],
                      if (detected && toxicGroups.isNotEmpty) ...[
                        _buildCombinedCard(
                          isToxic: true,
                          totalCount: toxicCount,
                          groupedEntries: toxicGroups,
                          isDark: isDark,
                          context: context,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (detected && nonToxicGroups.isNotEmpty) ...[
                        _buildCombinedCard(
                          isToxic: false,
                          totalCount: nonToxicCount,
                          groupedEntries: nonToxicGroups,
                          isDark: isDark,
                          context: context,
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 8,
                              fontFamily: 'HindVadodara',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.4),
                            ),
                            children: const [
                              TextSpan(text: 'Note: '),
                              TextSpan(
                                text: 'ToxiCrab',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' is limited to detecting 19 crab species, comprising 5 toxic and 14 non-toxic. It is designed to support safety awareness and education. Results are for guidance only and are not a substitute for professional or expert identification.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (detected) ...[
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveResult,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.save_alt_rounded, size: 20),
                      label: Text(
                        _isSaving ? 'Saving...' : 'Save Result',
                        style: const TextStyle(
                          fontFamily: 'HindVadodara',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDB850),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade600,
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bounding box painter ────────────────────────────────────────────────────
class MultiBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> detections;
  final double imageWidth;
  final double imageHeight;
  final double displayWidth;
  final double displayHeight;

  MultiBoxPainter({
    required this.detections,
    required this.imageWidth,
    required this.imageHeight,
    required this.displayWidth,
    required this.displayHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (detections.isEmpty) return;

    final double scaleX = displayWidth / imageWidth;
    final double scaleY = displayHeight / imageHeight;
    final double scale = scaleX > scaleY ? scaleX : scaleY;

    final double offsetX = (displayWidth - imageWidth * scale) / 2;
    final double offsetY = (displayHeight - imageHeight * scale) / 2;

    for (final d in detections) {
      final bbox = d["bbox"] as Map<String, dynamic>;
      final bool isToxic = d["is_toxic"] == true;
      final double confidence = (d["confidence"] as num).toDouble();
      final String species = (d["species"] as String).replaceAll('_', ' ');
      final String label =
          '${species[0].toUpperCase()}${species.substring(1)}  ${confidence.toStringAsFixed(1)}%';

      final Color boxColor = isToxic ? Colors.red : Colors.green;

      final double x1 = (bbox["x1"] as num).toDouble() * scale + offsetX;
      final double y1 = (bbox["y1"] as num).toDouble() * scale + offsetY;
      final double x2 = (bbox["x2"] as num).toDouble() * scale + offsetX;
      final double y2 = (bbox["y2"] as num).toDouble() * scale + offsetY;

      canvas.drawRect(
        Rect.fromLTRB(x1, y1, x2, y2),
        Paint()
          ..color = boxColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0,
      );

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const double pad = 4;
      final double lw = tp.width + pad * 2;
      final double lh = tp.height + pad * 2;

      canvas.drawRect(
        Rect.fromLTWH(x1, y1 - lh, lw, lh),
        Paint()..color = boxColor,
      );
      tp.paint(canvas, Offset(x1 + pad, y1 - lh + pad));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}