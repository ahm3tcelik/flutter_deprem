import 'package:flutter/material.dart';
import 'package:flutter_deprem/models/deprem.dart';
import 'package:flutter_deprem/pages/deprem_detail.dart';
import 'package:flutter_deprem/services/rss_service.dart';

class DepremlerPage extends StatefulWidget {
  const DepremlerPage({Key? key}) : super(key: key);

  @override
  _DepremlerPageState createState() => _DepremlerPageState();
}

class _DepremlerPageState extends State<DepremlerPage> {
  final rssService = RssService.instance;
  List<Deprem>? list;

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  void loadFromLocal() {
    // sql den verileri çekcek
    /*
    setState(() {
      list = _list;
    });
    
     */
  }
  void loadFromRemote() async {
    // RSS DEN GELEN VERİLER SQLITE REPLACE EDILECEK
    rssService.fetch().then((_list) {
      loadFromLocal();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Liste yenilendi'),
      ));
    });
  }

  Future onRefresh() async {
    loadFromRemote();
  }

  void onSearch(String key) {
    // search local db then setState list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Depremler'),
      ),
      body: Builder(
        builder: (context) {
          if (list == null) return CircularProgressIndicator();
          if (list!.isEmpty) return Center(child: Text('Maalesef veri yok'));
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearch(),
        const SizedBox(height: 4),
        Expanded(child: _buildDepremListView())
      ],
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Ara...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDepremListView() {
    final _list = list ?? [];
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: _list.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepremDetailPage(deprem: _list[index]),
              ),
            );
          },
          leading: CircleAvatar(
            child: Text(_list[index].buyukluk),
          ),
          title: Text(_list[index].baslik),
          subtitle: Row(
            children: [
              Icon(Icons.date_range_sharp, size: 13),
              const SizedBox(width: 4),
              Text(_list[index].tarih),
              const SizedBox(width: 4),
              Icon(Icons.watch_later_outlined, size: 13),
              const SizedBox(width: 4),
              Text(_list[index].saat)
            ],
          ),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
