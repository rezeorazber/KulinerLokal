// ignore_for_file: prefer_const_constructors
import '../models/culinary_place.dart';
import '../models/menu_item.dart';
import '../models/review_model.dart';

class MockCulinaryData {
  static List<CulinaryPlace> get places => [
    // ==================== MAKANAN ====================
    CulinaryPlace(
      id: 'gudeg_yu_djum',
      name: 'Gudeg Yu Djum Wijilan',
      category: 'Makanan',
      district: 'Kota Yogyakarta',
      rating: 4.8,
      reviewCount: 4210,
      priceRange: 'Rp 25.000 - Rp 65.000',
      address: 'Jl. Wijilan No.167, Panembahan, Kraton, Kota Yogyakarta',
      latitude: -7.804825,
      longitude: 110.366755,
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
      ],
      isOperational: true,
      openHours: '06.00 - 22.00 WIB',
      distanceKm: 0.8,
      isFavorite: true,
      description:
      'Gudeg kering khas Yogyakarta yang dimasak dengan kayu bakar secara tradisional selama berjam-jam.',
      featuredMenus: [
        MenuItem(
          id: 'm1',
          name: 'Nasi Gudeg Komplit',
          price: 35000,
          imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
          description: 'Gudeg nangka manis, krecek pedas, sambal goreng, ayam suwir, dan telur bacem.',
        ),
        MenuItem(
          id: 'm2',
          name: 'Paket Besek Kendil Ayam Utuh',
          price: 180000,
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
          description: 'Paket oleh-oleh kendil lengkap dengan ayam kampung utuh dan 5 telur bacem.',
        ),
      ],
      reviews: [
        ReviewModel(id: 'r1', author: 'Budi Santoso', rating: 5.0, comment: 'Rasa gudegnya tidak terlalu manis!', date: '2 hari lalu'),
      ],
    ),

    CulinaryPlace(
      id: 'sate_pak_pong',
      name: 'Sate Klathak Pak Pong',
      category: 'Makanan',
      district: 'Bantul',
      rating: 4.7,
      reviewCount: 3890,
      priceRange: 'Rp 30.000 - Rp 50.000',
      address: 'Jl. Imogiri Timur No.KM 10, Jejeran II, Pleret, Bantul',
      latitude: -7.868721,
      longitude: 110.390145,
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1544025162-d76694265947?w=800',
        'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=800',
        'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
      ],
      isOperational: true,
      openHours: '09.00 - 23.00 WIB',
      distanceKm: 8.4,
      isFavorite: true,
      description: 'Sate kambing muda khas Bantul yang ditusuk menggunakan jeruji besi.',
      featuredMenus: [
        MenuItem(id: 'sp1', name: 'Sate Klathak', price: 32000, imageUrl: 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=800', description: 'Daging kambing muda empuk.'),
      ],
      reviews: [
        ReviewModel(id: 'sr1', author: 'Arif Prasetyo', rating: 5.0, comment: 'Empuk banget!', date: '3 hari lalu'),
      ],
    ),

    CulinaryPlace(
      id: 'mangut_mbah_marto',
      name: 'Mangut Lele Mbah Marto',
      category: 'Makanan',
      district: 'Bantul',
      rating: 4.9,
      reviewCount: 3120,
      priceRange: 'Rp 20.000 - Rp 40.000',
      address: 'Dusun Ireng-ireng, Panggungharjo, Sewon, Bantul',
      latitude: -7.846512,
      longitude: 110.354120,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
        'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
      ],
      isOperational: true,
      openHours: '10.00 - 21.00 WIB',
      distanceKm: 6.1,
      isFavorite: false,
      description: 'Pengunjung masuk langsung ke dapur pawon tradisional.',
      featuredMenus: [
        MenuItem(id: 'ml1', name: 'Mangut Lele Asap', price: 25000, imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800', description: 'Lele asap kuah santan pedas.'),
      ],
      reviews: [
        ReviewModel(id: 'mr1', author: 'Lina Marlina', rating: 5.0, comment: 'Pedasnya mantap!', date: '5 hari lalu'),
      ],
    ),

    CulinaryPlace(
      id: 'bakmi_pak_pale',
      name: 'Bakmi Jawa Pak Pale',
      category: 'Makanan',
      district: 'Kota Yogyakarta',
      rating: 4.7,
      reviewCount: 1680,
      priceRange: 'Rp 20.000 - Rp 35.000',
      address: 'Jl. Pojok Beteng Wetan No.12, Panembahan, Kraton',
      latitude: -7.817340,
      longitude: 110.370550,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
        'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=800',
        'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?w=800',
      ],
      isOperational: true,
      openHours: '18.00 - 00.30 WIB',
      distanceKm: 2.3,
      isFavorite: false,
      description: 'Bakmi Jawa klasik yang dimasak di atas anglo arang.',
      featuredMenus: [
        MenuItem(id: 'bp1', name: 'Bakmi Godhog Nyemek', price: 25000, imageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=800', description: 'Bakmi kuah kental gurih.'),
      ],
      reviews: [
        ReviewModel(id: 'bpr1', author: 'Hendro Wijaya', rating: 4.7, comment: 'Kuah nyemeknya legit.', date: '1 minggu lalu'),
      ],
    ),

    CulinaryPlace(
      id: 'jejamuran_sleman',
      name: 'Resto Jejamuran',
      category: 'Makanan',
      district: 'Sleman',
      rating: 4.7,
      reviewCount: 4600,
      priceRange: 'Rp 20.000 - Rp 60.000',
      address: 'Jl. Magelang KM 13, Niron, Pandowoharjo, Sleman',
      latitude: -7.712140,
      longitude: 110.358910,
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      ],
      isOperational: true,
      openHours: '09.00 - 21.00 WIB',
      distanceKm: 11.2,
      isFavorite: false,
      description: 'Restoran tematik olahan berbagai jamur.',
      featuredMenus: [
        MenuItem(id: 'jj1', name: 'Sate Jamur Tiram', price: 22000, imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800', description: 'Jamur tiram bakar bumbu kacang.'),
      ],
      reviews: [
        ReviewModel(id: 'jjr1', author: 'Dian Permata', rating: 4.8, comment: 'Enak dan nyaman.', date: '2 minggu lalu'),
      ],
    ),

    // ==================== MINUMAN ====================
    CulinaryPlace(
      id: 'kopi_joss_lik_man',
      name: 'Kopi Joss Lik Man',
      category: 'Minuman',
      district: 'Kota Yogyakarta',
      rating: 4.6,
      reviewCount: 2450,
      priceRange: 'Rp 5.000 - Rp 20.000',
      address: 'Jl. Wongsodirjan, Sosromenduran, Gedongtengen, Kota Yogyakarta',
      latitude: -7.789125,
      longitude: 110.364512,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800',
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800',
        'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=800',
      ],
      isOperational: true,
      openHours: '17.00 - 02.00 WIB',
      distanceKm: 1.2,
      isFavorite: false,
      description: 'Kopi hitam tubruk dicelupkan arang kayu membara.',
      featuredMenus: [
        MenuItem(id: 'kj1', name: 'Kopi Joss Arang', price: 6000, imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800', description: 'Kopi arang membara.'),
      ],
      reviews: [
        ReviewModel(id: 'kr1', author: 'Farhan Maulana', rating: 4.8, comment: 'Ikonik!', date: 'Kemarin'),
      ],
    ),

    CulinaryPlace(
      id: 'kopi_klotok',
      name: 'Kopi Klotok Pakem',
      category: 'Minuman',
      district: 'Sleman',
      rating: 4.7,
      reviewCount: 5200,
      priceRange: 'Rp 8.000 - Rp 30.000',
      address: 'Jl. Kaliurang KM 22, Pakem, Sleman',
      latitude: -7.604181,
      longitude: 110.423988,
      imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800',
        'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=800',
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800',
      ],
      isOperational: true,
      openHours: '07.00 - 17.00 WIB',
      distanceKm: 18.3,
      isFavorite: false,
      description: 'Kedai kopi legendaris di lereng Merapi.',
      featuredMenus: [
        MenuItem(id: 'kk1', name: 'Kopi Klotok Tubruk', price: 10000, imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800', description: 'Kopi tubruk gula jawa.'),
      ],
      reviews: [
        ReviewModel(id: 'kkr1', author: 'Rina Wardani', rating: 5.0, comment: 'Asri banget!', date: '4 hari lalu'),
      ],
    ),

    CulinaryPlace(
      id: 'wedang_ronde_mbah_payem',
      name: 'Wedang Ronde Mbah Payem',
      category: 'Minuman',
      district: 'Kota Yogyakarta',
      rating: 4.5,
      reviewCount: 1850,
      priceRange: 'Rp 8.000 - Rp 15.000',
      address: 'Jl. Malioboro No.93, Sosromenduran, Gedongtengen, Kota Yogyakarta',
      latitude: -7.793361,
      longitude: 110.365580,
      imageUrl: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800',
        'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=800',
        'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=800',
      ],
      isOperational: true,
      openHours: '16.00 - 23.00 WIB',
      distanceKm: 1.0,
      isFavorite: false,
      description: 'Minuman tradisional hangat khas Malioboro.',
      featuredMenus: [
        MenuItem(id: 'wr1', name: 'Wedang Ronde Komplit', price: 12000, imageUrl: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800', description: 'Bola ketan isi kacang kuah jahe.'),
      ],
      reviews: [
        ReviewModel(id: 'wrr1', author: 'Maya Indah', rating: 4.8, comment: 'Hangat!', date: '6 hari lalu'),
      ],
    ),

    CulinaryPlace(
      id: 'es_dawet_ngudi_rasa',
      name: 'Es Dawet Ngudi Rasa',
      category: 'Minuman',
      district: 'Kota Yogyakarta',
      rating: 4.6,
      reviewCount: 1420,
      priceRange: 'Rp 8.000 - Rp 12.000',
      address: 'Jl. Sosrowijayan No.31, Sosromenduran, Gedongtengen, Kota Yogyakarta',
      latitude: -7.788420,
      longitude: 110.364190,
      imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=800',
      imageUrls: [
        'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=800',
        'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800',
        'https://images.unsplash.com/photo-1527661591475-527312dd65f5?w=800',
      ],
      isOperational: true,
      openHours: '09.00 - 21.00 WIB',
      distanceKm: 1.3,
      isFavorite: false,
      description: 'Es dawet khas Jawa dengan cendol pandan.',
      featuredMenus: [
        MenuItem(id: 'ed1', name: 'Es Dawet Ayu', price: 10000, imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=800', description: 'Cendol santan gula merah.'),
      ],
      reviews: [
        ReviewModel(id: 'edr1', author: 'Putu Ayu', rating: 4.7, comment: 'Segar!', date: '3 hari lalu'),
      ],
    ),
  ];

  static const List<String> categories = ['Semua', 'Makanan', 'Minuman'];
}