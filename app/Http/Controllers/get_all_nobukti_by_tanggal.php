<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class get_all_nobukti_by_tanggal extends Controller
{


    // public function index()
    // {
    //     // return view('tesApiCath');
    //     return response()->json(['message' => 'API is working']);
    // }

    public function getData()
    {
        $listData = DB::connection('SML')->select('
         SELECT TANGGAL, NOBUKTI
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
            if (!isset($formattedData[$item->TANGGAL])) {
                $formattedData[$item->TANGGAL] = [];
            }
            $formattedData[$item->TANGGAL][] = $item->NOBUKTI;
        }

        $finalOutput = [];
        foreach ($formattedData as $tanggal => $NOBUKTIs) {
            $finalOutput[] = [
                'TANGGAL' => $tanggal,
                'NOBUKTI' => $NOBUKTIs
            ];
        }
        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $finalOutput
        ]);
    }
}
