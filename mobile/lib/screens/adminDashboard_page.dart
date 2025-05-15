import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/dashboard_stats.dart';
import 'package:mobile/services/statistics_service.dart';
import 'package:mobile/utils/app_bar_controller.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final StatisticsService _statsService = StatisticsService();

  DashboardStats _stats = DashboardStats.empty();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Load data as soon as the widget initializes
    _loadDashboardData();

    // Set up the app bar after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCustomAppBar();
    });
  }

  @override
  void dispose() {
    // Use a post-frame callback to reset the app bar
    // This prevents the "setState during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        final appBarController = Provider.of<AppBarController>(context, listen: false);
        appBarController.resetToDefault();
      }
    });
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final stats = await _statsService.getAllDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  void _setCustomAppBar() {
    if (!mounted || !context.mounted) return;

    final appBar = AppBar(
      title: const Text('Dashboard Administrativo'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
        ),
      ],
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    final appBarController = Provider.of<AppBarController>(context, listen: false);
    appBarController.setAppBar(appBar);
  }

  void _refreshData() {
    _loadDashboardData();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Falha ao carregar dados'),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
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

  // Rest of your widget building methods stay the same
  // ...

  // Widget para os cartões de estatísticas
  Widget _buildStatisticsCards() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      children: [
        _buildStatCard(
          'Total de Estudantes',
          _stats.totalStudents.toString(),
          Icons.school,
          Colors.blue,
        ),
        _buildStatCard(
          'Total de Proprietários',
          _stats.totalOwners.toString(),
          Icons.person,
          Colors.green,
        ),
        _buildStatCard(
          'Propriedades Ativas',
          _stats.totalProperties.toString(),
          Icons.home,
          Colors.orange,
        ),
        _buildStatCard(
          'Receita Mensal',
          currencyFormat.format(_stats.monthlyRent),
          Icons.attach_money,
          Colors.purple,
        ),
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