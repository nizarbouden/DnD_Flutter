import 'package:flutter/material.dart';
import 'package:dungeon_master/service/icon_service.dart';
import 'Homepage.dart';
import 'NotificationsPage.dart';
import 'ShopManagementPage.dart';
import 'UserManagementPage.dart';

class IconPlayer extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  IconPlayer({required this.user});

  @override
  _IconPlayerState createState() => _IconPlayerState();
}

class _IconPlayerState extends State<IconPlayer> {
  int _currentIndex = 0;
  final IconService _iconService = IconService();
  ValueNotifier<List<Map<String, dynamic>>> iconsNotifier = ValueNotifier([]);

  TextEditingController _searchController = TextEditingController();
  String selectedFilter = '';
  bool isAscendingName = true;

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchIcons();
  }

  Future<void> fetchIcons() async {
    try {
      final fetchedIcons = await _iconService.fetchIcons();
      iconsNotifier.value = List.from(fetchedIcons);
    } catch (e) {
      print('Error fetching icons: $e');
    }
  }

  List<Map<String, dynamic>> _getPaginatedIcons(
      List<Map<String, dynamic>> iconList) {
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    return iconList.sublist(
        start, end > iconList.length ? iconList.length : end);
  }

  void sortByName() {
    setState(() {
      isAscendingName = !isAscendingName;
      selectedFilter = 'name';
      iconsNotifier.value.sort((a, b) => isAscendingName
          ? a['name'].toString().compareTo(b['name'].toString())
          : b['name'].toString().compareTo(a['name'].toString()));
    });
  }

  void clearFilters() {
    setState(() {
      selectedFilter = '';
      _searchController.clear();
      _currentPage = 1;
      fetchIcons();
    });
  }

  void _showAddIconDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    // List of available icons
    final List<String> iconList = [
      'avataricon1.webp',
      'avataricon2.webp',
      'avataricon3.webp',
      'avataricon4.webp',
      'avataricon5.webp',
      'avataricon6.webp',
      'avataricon7.webp',
      'avataricon8.webp',
      'avataricon9.webp',
      'avataricon10.webp',
      'avataricon11.webp',
      'avataricon12.webp',
      'avataricon13.webp',
      'avataricon14.webp',
      'avataricon15.webp',
    ];

    String? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                      'Add New Icon',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Icon Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Icon Name',
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

                    // Dropdown for Icon Image Selection
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
                        hint: const Text('Select Icon Image'),
                        dropdownColor: Colors.white,
                        value: selectedImage,
                        items: iconList.map((iconName) {
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

                    // Description Field
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
                    const SizedBox(height: 24),

                    // Create Button
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final desc = descController.text.trim();

                        if (name.isEmpty ||
                            desc.isEmpty ||
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

                        final newIcon = await _iconService.createIcon(
                          name: name,
                          image: selectedImage!,
                          desc: desc,
                        );

                        if (newIcon != null) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Icon "${newIcon['name']}" created successfully.'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                          fetchIcons();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to create icon.'),
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
                        'Create Icon',
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

  void _showEditIconDialog(Map<String, dynamic> iconData) {
    final TextEditingController nameController =
        TextEditingController(text: iconData['name']);
    final TextEditingController descController =
        TextEditingController(text: iconData['desc']);

    // List of available icons
    final List<String> iconList = [
      'avataricon1.webp',
      'avataricon2.webp',
      'avataricon3.webp',
      'avataricon4.webp',
      'avataricon5.webp',
      'avataricon6.webp',
      'avataricon7.webp',
      'avataricon8.webp',
      'avataricon9.webp',
      'avataricon10.webp',
      'avataricon11.webp',
      'avataricon12.webp',
      'avataricon13.webp',
      'avataricon14.webp',
      'avataricon15.webp',
    ];

    String? selectedImage = iconData['image'];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                      'Edit Icon',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Icon Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Icon Name',
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

                    // Dropdown for Icon Image Selection
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
                        hint: const Text('Select Icon Image'),
                        dropdownColor: Colors.white,
                        value: selectedImage,
                        items: iconList.map((iconName) {
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

                    // Description Field
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
                    const SizedBox(height: 24),

                    // Update Button
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final desc = descController.text.trim();

                        if (name.isEmpty ||
                            desc.isEmpty ||
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

                        final updatedIcon = await _iconService.updateIcon(
                          id: iconData['_id'],
                          name: name,
                          image: selectedImage!,
                          desc: desc,
                        );

                        if (updatedIcon != null) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Icon "${updatedIcon['name']}" updated successfully.'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                          fetchIcons();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update icon.'),
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
                        'Update Icon',
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

  Future<void> _confirmDeleteIcon(Map<String, dynamic> iconData) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete "${iconData['name']}"?'),
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
      // User confirmed deletion
      bool deleted = await _iconService.deleteIcon(iconData['_id']);
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Icon "${iconData['name']}" deleted successfully.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        fetchIcons();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete icon.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showIconDetailsDialog(
      BuildContext context, Map<String, dynamic> iconData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/${iconData['image'] ?? 'default_icon.png'}'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 12),

                  // Icon Name
                  Text(
                    iconData['name'] ?? 'Unknown Icon',
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

                  // Icon Description
                  Text(
                    iconData['desc'] ?? 'No description available.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg_dash.webp',
              fit: BoxFit.cover,
            ),
          ),
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
                    hintText: 'Search icons...',
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    color: const Color(0xFFD4CFC4),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationsPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                ],
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
                          color: Colors.black54,
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
                            valueListenable: iconsNotifier,
                            builder: (context, iconList, _) {
                              int totalPages =
                                  (iconList.length / _itemsPerPage).ceil();
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
                                  (iconsNotifier.value.length / _itemsPerPage)
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
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // List of Icons
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: iconsNotifier,
                  builder: (context, iconList, _) {
                    // Filter by search
                    var filteredIcons = iconList
                        .where((icon) => icon['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                    var paginatedIcons = _getPaginatedIcons(filteredIcons);

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: paginatedIcons.length,
                      itemBuilder: (context, index) {
                        final iconData = paginatedIcons[index];
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
                                  // Icon Image
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'assets/${iconData['image'] ?? 'default_icon.png'}'),
                                    onBackgroundImageError: (_, __) {
                                      print(
                                          'Error loading icon image: ${iconData['image']}');
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  // Icon Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          iconData['name'] ?? 'No Name',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          iconData['desc'] ?? 'No Description',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Action Buttons (Info, Edit, Delete)
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Image.asset('assets/infoicf.png',
                                            width: 30, height: 30),
                                        onPressed: () {
                                          _showIconDetailsDialog(
                                              context, iconData);
                                        },
                                        tooltip: 'View Details',
                                      ),
                                      IconButton(
                                        icon: Image.asset('assets/modic.png',
                                            width: 30, height: 30),
                                        onPressed: () {
                                          _showEditIconDialog(iconData);
                                        },
                                        tooltip: 'Edit Icon',
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
                                          await _confirmDeleteIcon(iconData);
                                        },
                                        tooltip: 'Delete Icon',
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
        onPressed: _showAddIconDialog,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add New Icon',
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF7A393D),
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD4CFC4),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'VecnaBold',
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'VecnaBold',
          fontSize: 15,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user: widget.user),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopManagementPage(user: widget.user),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserManagementPage(user: widget.user),
              ),
            );
          } else if (index == 3) {
            // Navigate to Profile or Settings page if you have one
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/homeicnav.png'),
              size: 20,
              color: Color(0xFFD4CFC4),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/shopnav.png'),
              size: 30,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/playersnav.png'),
              size: 30,
            ),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/profilenav.png'),
              size: 25,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
