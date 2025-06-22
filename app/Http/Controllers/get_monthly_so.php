<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class get_monthly_so extends Controller
{


    public function getMonthlyData()
    {
        $results = DB::connection('SML')->select('
        SELECT 
            DATENAME(month, TANGGAL) AS month_name,
            COUNT(*) AS total
        FROM DBSO
        WHERE YEAR(TANGGAL) = 2024
        GROUP BY DATENAME(month, TANGGAL), MONTH(TANGGAL)
        ORDER BY MONTH(TANGGAL)
    ');

        $data = [];
        foreach ($results as $row) {
            $data[$row->month_name] = $row->total;
        }

        return response()->json([
            'data' => $data
        ]);
    }

    // public function getMonthlyData()
    // {
    //     $results =
    //         DB::connection('SML')
    //             ->table('DBSO')
    //             ->selectRaw('MONTH(TANGGAL) as month, COUNT(*) as total')
    //             ->whereYear('TANGGAL', '=', 2024)
    //             ->groupBy(DB::raw('MONTH(TANGGAL)'))
    //             ->get();

    //     $monthNames = [
    //         1 => 'January',
    //         2 => 'February',
    //         3 => 'March',
    //         4 => 'April',
    //         5 => 'May',
    //         6 => 'June',
    //         7 => 'July',
    //         8 => 'August',
    //         9 => 'September',
    //         10 => 'October',
    //         11 => 'November',
    //         12 => 'December',
    //     ];

    //     // Initialize all months with 0
    //     $data = array_fill_keys(array_values($monthNames), 0);

    //     foreach ($results as $result) {
    //         $monthName = $monthNames[$result->month];
    //         $data[$monthName] = $result->total;
    //     }

    //     return response()->json(['data' => $data]);
    // }
}
