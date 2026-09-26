import '../models/dealer.dart';

/// Provides the dealer directory backing the trusted-vs-untrustworthy
/// dealer map/list.
///
/// Backed by a fixed seed list for now; the aggregated dealer trust score
/// this repository exposes (via [Dealer.isTrusted]) is exactly the kind of
/// heat-map input that gets sold to brands/donor programs, so keeping the
/// scoring logic here (not scattered in widgets) matters for that future
/// export/reporting pipeline.
class DealerRepository {
  List<Dealer> getDealers() => const [
        Dealer(
          id: 'd1',
          name: 'Kano Agro Supplies',
          location: 'Kano, Kano State',
          latitude: 12.0022,
          longitude: 8.5920,
          rating: 4.6,
          reportsCount: 0,
        ),
        Dealer(
          id: 'd2',
          name: 'Zaria Farmers Depot',
          location: 'Zaria, Kaduna State',
          latitude: 11.0855,
          longitude: 7.7199,
          rating: 4.1,
          reportsCount: 1,
        ),
        Dealer(
          id: 'd3',
          name: 'Quick Harvest Agro Store',
          location: 'Minna, Niger State',
          latitude: 9.6139,
          longitude: 6.5569,
          rating: 2.3,
          reportsCount: 5,
        ),
        Dealer(
          id: 'd4',
          name: 'Green Fields Inputs Ltd',
          location: 'Ibadan, Oyo State',
          latitude: 7.3775,
          longitude: 3.9470,
          rating: 4.8,
          reportsCount: 0,
        ),
      ];
}
