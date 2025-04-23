import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:mobile/utils/app_bar_controller.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  @override
  void initState() {
    super.initState();
    // Execute após a conclusão do primeiro quadro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCustomAppBar();
    });
  }

  @override
  void dispose() {
    Provider.of<AppBarController>(context, listen: false).resetToDefault();
    super.dispose();
  }

  void _setCustomAppBar() {
    final appBar = AppBar(
      title: const Text('Dashboard Administrativo'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
        ),
      ],
      automaticallyImplyLeading: true, // Isto deveria mostrar o botão de voltar
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
          // Navegar para a tela admin
           // Volta para a página anterior
        },
      ),
    );

    Provider.of<AppBarController>(context, listen: false).setAppBar(appBar);
  }

  void _refreshData() {
    // Your refresh logic
  }

  void _openDashboardSettings() {
    // Your settings logic
  }


  final currencyFormat = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  // Dados simulados para os gráficos
  final List<FlSpot> cadastrosMensais = [
    FlSpot(1, 10),
    FlSpot(2, 15),
    FlSpot(3, 20),
    FlSpot(4, 25),
    FlSpot(5, 22),
    FlSpot(6, 35),
  ];

  @override
  Widget build(BuildContext context) {
    final appBar = Provider.of<AppBarController>(context).currentAppBar;
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Admin',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Usuários'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Propriedades'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text('Pagamentos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report_problem),
              title: const Text('Denúncias'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cartões de estatísticas gerais
            _buildStatisticsCards(),
            const SizedBox(height: 24),

            // Gráfico de tendências
            _buildSectionTitle('Tendências de Cadastro'),
            _buildLineChart(),
            const SizedBox(height: 24),

            // Mapa de propriedades
            _buildSectionTitle('Distribuição de Propriedades'),
            _buildMap(),
            const SizedBox(height: 24),

            // Gráficos comparativos


            // Tabela de propriedades populares
            _buildSectionTitle('Propriedades Mais Visualizadas'),
            _buildPopularPropertiesTable(),
            const SizedBox(height: 24),

            // Últimas atividades
            _buildSectionTitle('Atividades Recentes'),
            _buildRecentActivityList(),
          ],
        ),
      ),
    );
  }

  // Widget para os cartões de estatísticas
  Widget _buildStatisticsCards() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      children: [
        _buildStatCard('Total de Estudantes', '1,245', Icons.school, Colors.blue),
        _buildStatCard('Total de Proprietários', '387', Icons.person, Colors.green),
        _buildStatCard('Propriedades Ativas', '629', Icons.home, Colors.orange),
        _buildStatCard('Receita Mensal', currencyFormat.format(12500), Icons.attach_money, Colors.purple),
      ],
    );
  }

  // Widget para cada cartão de estatística
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para os títulos de seção
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget para o gráfico de linha
  Widget _buildLineChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const months = ['', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'];
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toInt() < months.length ? months[value.toInt()] : '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: cadastrosMensais,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para o mapa
  Widget _buildMap() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(-23.5505, -46.6333), // São Paulo
          zoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(-23.5505, -46.6333),
                width: 80,
                height: 80,
                child: const Icon(  // Changed from 'builder' to 'child'
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              // Add more markers as needed
            ],
          ),
        ],
      ),
    );
  }

  // Widget para linha de gráficos
  Widget _buildChartRow() {
    return Row(
      children: [
        Expanded(child: _buildPieChart()),
        const SizedBox(width: 16),
        Expanded(child: _buildBarChart()),
      ],
    );
  }

  // Widget para gráfico de pizza
  Widget _buildPieChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              value: 40,
              title: '40%',
              color: Colors.blue,
              radius: 50,
            ),
            PieChartSectionData(
              value: 30,
              title: '30%',
              color: Colors.green,
              radius: 50,
            ),
            PieChartSectionData(
              value: 15,
              title: '15%',
              color: Colors.orange,
              radius: 50,
            ),
            PieChartSectionData(
              value: 15,
              title: '15%',
              color: Colors.purple,
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }

  // Widget para gráfico de barras
  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: 20,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const regions = ['', 'Centro', 'Norte', 'Sul', 'Leste', 'Oeste'];
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toInt() < regions.length ? regions[value.toInt()] : '',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          barGroups: [
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(toY: 15, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(toY: 8, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(toY: 12, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(toY: 7, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(toY: 10, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para tabela de propriedades populares
  Widget _buildPopularPropertiesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Propriedade',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Visualizações',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Contatos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Taxa de Conv.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildPropertyRow('Apartamento Centro', 450, 35, '7.8%'),
          _buildPropertyRow('Kitnet Próx. USP', 387, 42, '10.9%'),
          _buildPropertyRow('Casa 3 Quartos', 320, 28, '8.8%'),
          _buildPropertyRow('Studio Mobiliado', 298, 31, '10.4%'),
          _buildPropertyRow('Apartamento 2 Quartos', 265, 22, '8.3%'),
        ],
      ),
    );
  }

  // Widget para linha da tabela de propriedades
  Widget _buildPropertyRow(String name, int views, int contacts, String rate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(name),
          ),
          Expanded(
            child: Text(views.toString()),
          ),
          Expanded(
            child: Text(contacts.toString()),
          ),
          Expanded(
            child: Text(rate),
          ),
        ],
      ),
    );
  }

  // Widget para lista de atividades recentes
  Widget _buildRecentActivityList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActivityItem(
            'João Silva cadastrou uma nova propriedade',
            '10 minutos atrás',
            Icons.home,
            Colors.green,
          ),
          _buildActivityItem(
            'Maria Oliveira contatou um proprietário',
            '25 minutos atrás',
            Icons.chat,
            Colors.blue,
          ),
          _buildActivityItem(
            'Pedro Santos atualizou informações de perfil',
            '1 hora atrás',
            Icons.person,
            Colors.orange,
          ),
          _buildActivityItem(
            'Ana Ferreira fez um pagamento',
            '2 horas atrás',
            Icons.payment,
            Colors.purple,
          ),
          _buildActivityItem(
            'Carlos Mendes reportou um problema',
            '3 horas atrás',
            Icons.report_problem,
            Colors.red,
          ),
        ],
      ),
    );
  }

  // Widget para item da lista de atividades
  Widget _buildActivityItem(String activity, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}