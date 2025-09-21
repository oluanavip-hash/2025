import React, { useState, useEffect } from 'react';
import StatCard from '../../components/dashboard/StatCard';
import SalesChart from '../../components/dashboard/SalesChart';
import OrderStatusPie from '../../components/dashboard/OrderStatusPie';
import RecentOrdersTable from '../../components/dashboard/RecentOrdersTable';
import { useAuth } from '../../contexts/AuthContext';
import { supabase } from '../../lib/supabaseClient';
import { DollarSign, ShoppingCart, Users, Wallet, PlusCircle, Loader2 } from 'lucide-react';

type OrderStatusUI = 'Pendente' | 'Enviado' | 'Entregue' | 'Cancelado';

const translateDbStatusToUi = (dbStatus: string): OrderStatusUI => {
    switch (dbStatus) {
        case 'pending_payment':
        case 'paid':
            return 'Pendente';
        case 'shipped':
            return 'Enviado';
        case 'delivered':
            return 'Entregue';
        case 'canceled':
            return 'Cancelado';
        default:
            return 'Pendente';
    }
};

const DashboardOverview: React.FC = () => {
  const { profile } = useAuth();
  const [loading, setLoading] = useState(true);
  const [totalRevenue, setTotalRevenue] = useState(0);
  const [monthlySales, setMonthlySales] = useState(0);
  const [totalCustomers, setTotalCustomers] = useState(0);
  const [salesChartData, setSalesChartData] = useState<{ labels: string[], data: number[] }>({ labels: [], data: [] });
  const [pieData, setPieData] = useState<{ value: number, name: string }[]>([]);
  const [recentOrders, setRecentOrders] = useState<any[]>([]);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);

      const { data: orders, error: ordersError } = await supabase
        .from('orders')
        .select('*')
        .order('created_at', { ascending: false });

      const { count: customersCount, error: customersError } = await supabase
        .from('profiles')
        .select('*', { count: 'exact', head: true });

      if (ordersError || customersError) {
        console.error('Error fetching dashboard data:', ordersError || customersError);
        setLoading(false);
        return;
      }
      
      // Process Stats
      const revenue = orders.reduce((sum, order) => sum + order.total_amount, 0);
      setTotalRevenue(revenue);

      const currentMonth = new Date().getMonth();
      const currentYear = new Date().getFullYear();
      const salesThisMonth = orders.filter(o => {
          const orderDate = new Date(o.created_at);
          return orderDate.getMonth() === currentMonth && orderDate.getFullYear() === currentYear;
      }).length;
      setMonthlySales(salesThisMonth);

      setTotalCustomers(customersCount || 0);

      // Process Sales Chart (last 6 months)
      const months = Array.from({ length: 6 }, (_, i) => {
        const d = new Date();
        d.setMonth(d.getMonth() - i);
        return { year: d.getFullYear(), month: d.getMonth(), name: d.toLocaleString('pt-BR', { month: 'short' }) };
      }).reverse();
      
      const monthlySalesData = months.map(m => {
        const total = orders
          .filter(o => {
            const orderDate = new Date(o.created_at);
            return orderDate.getFullYear() === m.year && orderDate.getMonth() === m.month;
          })
          .reduce((sum, o) => sum + o.total_amount, 0);
        return total;
      });

      setSalesChartData({
        labels: months.map(m => m.name.charAt(0).toUpperCase() + m.name.slice(1)),
        data: monthlySalesData,
      });

      // Process Pie Chart
      const statusCounts: Record<string, number> = { 'Pendente': 0, 'Enviado': 0, 'Entregue': 0, 'Cancelado': 0 };
      orders.forEach(order => {
        const uiStatus = translateDbStatusToUi(order.status);
        if (statusCounts[uiStatus] !== undefined) {
          statusCounts[uiStatus]++;
        }
      });
      const pieChartData = Object.entries(statusCounts)
        .map(([name, value]) => ({ name, value }))
        .filter(item => item.value > 0);
      setPieData(pieChartData);
      
      // Process Recent Orders
      const recent = orders.slice(0, 5).map(order => ({
        id: order.id.toString(),
        customer: order.customer_name,
        date: new Date(order.created_at).toLocaleDateString('pt-BR'),
        total: `R$ ${order.total_amount.toFixed(2).replace('.', ',')}`,
        status: translateDbStatusToUi(order.status),
      }));
      setRecentOrders(recent);

      setLoading(false);
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <div className="flex justify-center items-center h-[calc(100vh-120px)]">
        <Loader2 className="animate-spin text-red-600" size={48} />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="Saldo da Plataforma"
          value={`R$ ${profile?.balance.toFixed(2).replace('.', ',') ?? '0,00'}`}
          icon={<Wallet size={20} />}
          action={
            <button className="flex items-center gap-1 text-xs text-green-600 hover:text-green-700 font-semibold">
              <PlusCircle size={14} />
              Recarregar
            </button>
          }
        />
        <StatCard
          title="Faturamento Total"
          value={`R$ ${totalRevenue.toFixed(2).replace('.', ',')}`}
          icon={<DollarSign size={20} />}
          action={
             <span className="text-xs text-gray-400">Todas as vendas</span>
          }
        />
        <StatCard
          title="Vendas (Mês)"
          value={monthlySales.toString()}
          icon={<ShoppingCart size={20} />}
        />
        <StatCard
          title="Total de Clientes"
          value={totalCustomers.toString()}
          icon={<Users size={20} />}
        />
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-5">
        <div className="lg:col-span-3">
          <SalesChart labels={salesChartData.labels} data={salesChartData.data} />
        </div>
        <div className="lg:col-span-2">
          <OrderStatusPie data={pieData} />
        </div>
      </div>

      <div>
        <RecentOrdersTable orders={recentOrders} />
      </div>
    </div>
  );
};

export default DashboardOverview;
