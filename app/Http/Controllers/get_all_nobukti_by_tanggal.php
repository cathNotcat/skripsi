<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_all_nobukti_by_tanggal extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

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
            // Use TANGGAL as the key in the formatted data array
            if (!isset($formattedData[$item->TANGGAL])) {
                $formattedData[$item->TANGGAL] = [];
            }
            // Append the NOBUKTI to the array for that TANGGAL
            $formattedData[$item->TANGGAL][] = $item->NOBUKTI;
        }

        // Format the output to match your desired structure
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
