<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_kodecust_by_tanggalSO extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

    public function getData()
    {
        $listData = DB::connection('SML')->select('
        SELECT DISTINCT TANGGAL, KODECUST
            FROM DBSO
            WHERE TANGGAL IN (
                SELECT TANGGAL
                FROM DBSO
                GROUP BY TANGGAL
                HAVING COUNT(*) >= 5
            )
            ORDER BY TANGGAL DESC
      ');

        $formattedData = [];

        foreach ($listData as $item) {
            // Use TANGGAL as the key in the formatted data array
            if (!isset($formattedData[$item->TANGGAL])) {
                $formattedData[$item->TANGGAL] = [];
            }
            // Append the NOBUKTI to the array for that TANGGAL
            $formattedData[$item->TANGGAL][] = $item->KODECUST;
        }

        // Format the output to match your desired structure
        $finalOutput = [];
        foreach ($formattedData as $tanggal => $KODECUSTs) {
            $uniqueKODECUSTs = array_unique($KODECUSTs);
            $finalOutput[] = [
                'TANGGAL' => $tanggal,
                'KODECUST' => array_values($uniqueKODECUSTs)
            ];
        }
        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $finalOutput
        ]);
    }
}
