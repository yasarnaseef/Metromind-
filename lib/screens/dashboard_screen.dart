import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';


class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key,});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;


  //
  // final List<Map<String, dynamic>> _dummyTopSellingProducts = [
  //   {'name': 'Apple iphone 14', 'quantity': 50},
  //   {'name': 'Nike Air Max', 'quantity': 30},
  //   {'name': 'Sony WH-1000XM5', 'quantity': 20},
  // ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child:Consumer<DashboardProvider>(
            builder: (context,dashboardPro,child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Sales Card
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 6,
                          shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Today\'s Sales',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  semanticsLabel: 'Today\'s Sales',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹${dashboardPro.todaySalesAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.green.shade600,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  semanticsLabel: 'Today\'s sales: ₹${dashboardPro.todaySalesAmount.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  // Monthly Overview Card
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 6,
                          shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monthly Overview',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  semanticsLabel: 'Monthly Overview',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Total Sales: ₹${dashboardPro.monthlySalesAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  semanticsLabel: 'Total monthly sales: ₹${dashboardPro.monthlySalesAmount.toStringAsFixed(2)}',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Orders: ${dashboardPro.monthlyOrdersCount}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  semanticsLabel: 'Monthly orders: ${dashboardPro.monthlyOrdersCount}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  // Low Stock Alerts Card
                  Card(
                    elevation: 6,
                    shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Low Stock Alerts',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            semanticsLabel: 'Low Stock Alerts for items with less than 5 available',
                          ),
                          const SizedBox(height: 8),
                          if (dashboardPro.lowStockProductsList.isEmpty)
                            Text(
                              'No low stock items',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              semanticsLabel: 'No low stock items',
                            )
                          else
                            ...dashboardPro.lowStockProductsList.map(
                                  (product) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                                title: Text(
                                  product['name'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  semanticsLabel: 'Product: ${product['name']}',
                                ),
                                subtitle: Text(
                                  'Quantity: ${product['quantity']}',
                                  semanticsLabel: 'Quantity: ${product['quantity']}',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 13,),
                  // Top Selling Products Bar Chart
                  Card(
                    elevation: 6,
                    shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Selling Products',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            semanticsLabel: 'Top Selling Products',
                          ),
                          const SizedBox(height: 16),
              SizedBox(
              height: 250,
              child: BarChart(
              BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: dashboardPro.topSellingProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final productData = entry.value;
              return BarChartGroupData(
              x: index,
              barRods: [
              BarChartRodData(
              toY: (productData['quantity'] ?? 0).toDouble(),
              gradient: LinearGradient(
              colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              ],
              ),
              width: 16,
              borderRadius: BorderRadius.circular(4),
              ),
              ],
              );
              }).toList(),
              titlesData: FlTitlesData(
              leftTitles: AxisTitles(
              sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
              return Text(
              value.toInt().toString(),
              style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
              ),
              semanticsLabel: '${value.toInt()} units',
              );
              },
              ),
              ),
              bottomTitles: AxisTitles(
              sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < dashboardPro.topSellingProducts.length) {
              final productName =
              dashboardPro.topSellingProducts[index]['name']?.toString() ?? 'N/A';
              return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
              productName,
              style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: productName,
              ),
              );
              }
              return const Text('');
              },
              ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
              show: true,
              border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
              ),
              barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final productName =
              dashboardPro.topSellingProducts[groupIndex]['name']?.toString() ?? 'N/A';
              return BarTooltipItem(
              '$productName\n${rod.toY.toInt()} units',
              TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              ),
              );
              },
              ),
              ),
              ),
              ),
              ),

              ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}