import 'package:flutter/material.dart';
import 'package:dungeon_master/service/GmService.dart';

class GamemodesPage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  GamemodesPage({required this.user});

  @override
  _GamemodesPageState createState() => _GamemodesPageState();
}

class _GamemodesPageState extends State<GamemodesPage> {
  final GmService _gmService = GmService();
  ValueNotifier<List<Map<String, dynamic>>> gmNotifier = ValueNotifier([]);

  TextEditingController _searchController = TextEditingController();
  String selectedFilter = '';
  bool isAscendingName = true;

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchGms();
  }

  Future<void> fetchGms() async {
    try {
      final fetchedGms = await _gmService.fetchGms();
      gmNotifier.value = List.from(fetchedGms);
    } catch (e) {
      print('Error fetching game modes: $e');
    }
  }

  List<Map<String, dynamic>> _getPaginatedGms(
      List<Map<String, dynamic>> gmList) {
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    return gmList.sublist(start, end > gmList.length ? gmList.length : end);
  }

  void sortByName() {
    setState(() {
      isAscendingName = !isAscendingName;
      selectedFilter = 'name';
      gmNotifier.value.sort((a, b) => isAscendingName
          ? a['name'].toString().compareTo(b['name'].toString())
          : b['name'].toString().compareTo(a['name'].toString()));
    });
  }

  void clearFilters() {
    setState(() {
      selectedFilter = '';
      _searchController.clear();
      _currentPage = 1;
      fetchGms();
    });
  }

  void _showAddGmDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController promptController = TextEditingController();

    // Example list of images for game modes
    final List<String> gmImageList = [
      'narrativecampmode.webp',
      'coopmode.webp',
      'challengemode.webp',
      'moralitymode.webp',
      'cursedmode.webp',
    ];

    String? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/bg_friends.webp'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add New Game Mode',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Game Mode Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.9),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        hint: const Text('Select Game Mode Image'),
                        dropdownColor: Colors.white,
                        value: selectedImage,
                        items: gmImageList.map((iconName) {
                          return DropdownMenuItem<String>(
                            value: iconName,
                            child: Text(iconName,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedImage = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: promptController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Prompt',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final desc = descController.text.trim();
                        final prompt = promptController.text.trim();

                        if (name.isEmpty ||
                            desc.isEmpty ||
                            prompt.isEmpty ||
                            selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all fields and select an image.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final newGm = await _gmService.createGm(
                          name: name,
                          image: selectedImage!,
                          desc: desc,
                          prompt: prompt,
                        );

                        if (newGm != null) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Game Mode "${newGm['name']}" created successfully.'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                          fetchGms();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to create game mode.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A393D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Create Game Mode',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditGmDialog(Map<String, dynamic> gmData) {
    final TextEditingController nameController =
        TextEditingController(text: gmData['name']);
    final TextEditingController descController =
        TextEditingController(text: gmData['desc']);
    final TextEditingController promptController =
        TextEditingController(text: gmData['prompt']);

    final List<String> gmImageList = [
      'narrativecampmode.webp',
      'coopmode.webp',
      'challengemode.webp',
      'moralitymode.webp',
      'cursedmode.webp',
    ];

    String? selectedImage = gmData['image'];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/bg_friends.webp'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Game Mode',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Game Mode Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.9),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        hint: const Text('Select Game Mode Image'),
                        dropdownColor: Colors.white,
                        value: selectedImage,
                        items: gmImageList.map((iconName) {
                          return DropdownMenuItem<String>(
                            value: iconName,
                            child: Text(iconName,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedImage = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: promptController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Prompt',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final desc = descController.text.trim();
                        final prompt = promptController.text.trim();

                        if (name.isEmpty ||
                            desc.isEmpty ||
                            prompt.isEmpty ||
                            selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all fields and select an image.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final updatedGm = await _gmService.updateGm(
                          id: gmData['_id'],
                          name: name,
                          image: selectedImage!,
                          desc: desc,
                          prompt: prompt,
                        );

                        if (updatedGm != null) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Game Mode "${updatedGm['name']}" updated successfully.'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                          fetchGms();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update game mode.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A393D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Update Game Mode',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteGm(Map<String, dynamic> gmData) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${gmData['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      bool deleted = await _gmService.deleteGm(gmData['_id']);
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Game Mode "${gmData['name']}" deleted successfully.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        fetchGms();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete game mode.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showGmDetailsDialog(BuildContext context, Map<String, dynamic> gmData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/bg_friends.webp'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // GM Image
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/${gmData['image'] ?? 'default_icon.png'}'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 12),

                    // GM Name
                    Text(
                      gmData['name'] ?? 'Unknown Game Mode',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(
                      color: Color(0xFF4B4B4B),
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),

                    // GM Description
                    Text(
                      gmData['desc'] ?? 'No description available.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // GM Prompt
                    Text(
                      'Prompt: ${gmData['prompt'] ?? 'No prompt available.'}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Close',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A393D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isAscending,
      VoidCallback onSelected, bool isSelected) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (label != 'Clear Filters') ...[
              const SizedBox(width: 4),
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: const Color(0xFF000000),
              ),
            ],
          ],
        ),
        onSelected: (value) => onSelected(),
        selected: isSelected,
        selectedColor: const Color(0xFF7A393D),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? const Color(0xFFD4CFC4) : Colors.transparent,
            width: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image for the Entire Screen
          Positioned.fill(
            child: Image.asset(
              'assets/bg_dash.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Column(
            children: [
              // AppBar with Search
              AppBar(
                backgroundColor: const Color(0xFF502722),
                title: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _currentPage = 1;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search game modes...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color(0xFFD4CFC4),
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFFD4CFC4),
                    fontSize: 18,
                  ),
                ),
              ),

              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    padding: const EdgeInsets.all(6.0),
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFilterChip('Name', isAscendingName, sortByName,
                            selectedFilter == 'name'),
                        _buildFilterChip('Clear Filters', false, clearFilters,
                            selectedFilter == ''),
                      ],
                    ),
                  ),
                ),
              ),

              // Pagination Controls
              Column(
                children: [
                  // Top Gradient Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3E3E3E),
                          Color(0xFF6A4E23),
                          Color(0xFF4B4B4B),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg_friends.webp'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Color(0xFF000000)),
                            onPressed: _currentPage > 1
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                          ),
                          ValueListenableBuilder(
                            valueListenable: gmNotifier,
                            builder: (context, gmList, _) {
                              int totalPages =
                                  (gmList.length / _itemsPerPage).ceil();
                              return Text(
                                'Page $_currentPage of $totalPages',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward,
                                color: Color(0xFF000000)),
                            onPressed: () {
                              int totalPages =
                                  (gmNotifier.value.length / _itemsPerPage)
                                      .ceil();
                              if (_currentPage < totalPages) {
                                setState(() {
                                  _currentPage++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Gradient Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3E3E3E),
                          Color(0xFF6A4E23),
                          Color(0xFF4B4B4B),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // List of Game Modes
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: gmNotifier,
                  builder: (context, gmList, _) {
                    var filteredGms = gmList
                        .where((gm) => gm['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                    var paginatedGms = _getPaginatedGms(filteredGms);

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: paginatedGms.length,
                      itemBuilder: (context, index) {
                        final gmData = paginatedGms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/bg_friends.webp'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black26,
                                  BlendMode.darken,
                                ),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // GM Image
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'assets/${gmData['image'] ?? 'default_icon.png'}'),
                                    onBackgroundImageError: (_, __) {
                                      print(
                                          'Error loading game mode image: ${gmData['image']}');
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          gmData['name'] ?? 'No Name',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          gmData['desc'] ?? 'No Description',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Image.asset('assets/infoicf.png',
                                            width: 30, height: 30),
                                        onPressed: () {
                                          _showGmDetailsDialog(context, gmData);
                                        },
                                        tooltip: 'View Details',
                                      ),
                                      IconButton(
                                        icon: Image.asset('assets/modic.png',
                                            width: 30, height: 30),
                                        onPressed: () {
                                          _showEditGmDialog(gmData);
                                        },
                                        tooltip: 'Edit Game Mode',
                                      ),
                                      IconButton(
                                        icon: Image.asset(
                                          'assets/deleteic.png',
                                          width: 30,
                                          height: 30,
                                          color: Colors.red.shade200,
                                          colorBlendMode: BlendMode.srcIn,
                                        ),
                                        onPressed: () async {
                                          await _confirmDeleteGm(gmData);
                                        },
                                        tooltip: 'Delete Game Mode',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7A393D),
        onPressed: _showAddGmDialog,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add New Game Mode',
      ),
    );
  }
}
