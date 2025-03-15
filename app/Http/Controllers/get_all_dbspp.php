<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_all_dbspp extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

    public function getData()
    {
        $listData = DB::connection('SML')->select('
          SELECT NOBUKTI, TANGGAL, NOSHIP, KODECUSTSUPP, TGLKIRIM
          FROM DBSPP
          WHERE TANGGAL IN (
              SELECT TANGGAL
              FROM DBSPP
              GROUP BY TANGGAL
              HAVING COUNT(*) >= 5
          )
          ORDER BY TANGGAL DESC
      ');

        $formattedData = [];

        foreach ($listData as $item) {
            // Use TANGGAL as the key in the formatted data array
            if (!isset($formattedData[$item->TANGGAL])) {
                $formattedData[$item->TANGGAL] = [
                    'NOSHIP' => [],
                    'KODECUSTSUPP' => [],
                    'TGLKIRIM' => [],
                    'NOBUKTI' => [],
                ];
            }
            // Append the KODECUST to the array for that TANGGAL
            $formattedData[$item->TANGGAL]['NOSHIP'] = $item->NOSHIP;
            $formattedData[$item->TANGGAL]['KODECUSTSUPP'] = $item->KODECUSTSUPP;
            $formattedData[$item->TANGGAL]['TGLKIRIM'] = $item->TGLKIRIM;
            $formattedData[$item->TANGGAL]['NOBUKTI'] = $item->NOBUKTI;
        }

        // Format the output to match your desired structure
        $finalOutput = [];
        foreach ($formattedData as $tanggal => $data) {
            $finalOutput[] = [
                'TANGGAL' => $tanggal,
                'NOSHIP' => $data['NOSHIP'],
                'KODECUSTSUPP' => $data['KODECUSTSUPP'],
                'TGLKIRIM' => $data['TGLKIRIM'],
                'NOBUKTI' => $data['NOBUKTI'],
            ];
        }
        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $finalOutput
        ]);
    }
}
