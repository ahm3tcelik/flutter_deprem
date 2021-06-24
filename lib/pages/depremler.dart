import 'package:flutter/material.dart';
import 'package:flutter_deprem/models/deprem.dart';
import 'package:flutter_deprem/pages/deprem_detail.dart';
import 'package:flutter_deprem/services/rss_service.dart';
import 'package:flutter_deprem/services/sqlite/db_helper.dart';

class DepremlerPage extends StatefulWidget {
  const DepremlerPage({Key? key}) : super(key: key);

  @override
  _DepremlerPageState createState() => _DepremlerPageState();
}

class _DepremlerPageState extends State<DepremlerPage> {
  final rssService = RssService.instance;
  var dbHelper = DbHelper();
  List<Deprem>? list;

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  void loadFromLocal() {
    dbHelper.getDepremler().then((_list) {
      setState(() {
        list = _list;
      });
    });
  }

  void loadFromRemote() async {
    rssService.fetch().then((_list) async {
      await dbHelper.batchInsertOverWrite(_list);
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
    dbHelper.search(key).then((_list) {
      setState(() {
        list = _list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Depremler'),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
            children: [
          Expanded(child: _buildSearch()),
          const SizedBox(width: 4),
          _buildFilter(),
        ]),
        const SizedBox(height: 4),
        Expanded(
          child: Builder(
            builder: (context) {
              if (list == null)
                return Center(child: CircularProgressIndicator());
              if (list!.isEmpty)
                return Center(child: Text('Maalesef veri yok'));
              return _buildDepremListView();
            },
          ),
        )
      ],
    );
  }

  Widget _buildFilter() {
    return PopupMenuButton(
      icon: Icon(Icons.filter_alt, size: 30, color: Colors.blue,),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(
            value: "ASC",
            child: ListTile(
              title: Text("Şiddete Göre Artan"),
              trailing: Icon(Icons.arrow_upward),
            )),
        PopupMenuItem(
            value: "DESC",
            child: ListTile(
              title: Text("Şiddete Göre Azalan"),
              trailing: Icon(Icons.arrow_downward),
            )),
      ],
      onSelected: (value) {
        dbHelper.sortBy(value!).then((_list) {
          setState(() {
            list = _list;
          });
        });
      },
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
