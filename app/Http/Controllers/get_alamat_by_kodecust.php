<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_alamat_by_kodecust extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

    public function getData($kode)
    {
        $kodePattern = strtoupper($kode) . '%';

        $listData = DB::connection('SML')->select('
          SELECT KODECUSTSUPP, NAMA, ALAMAT, KOORDINAT
          FROM DBALAMATCUST
          WHERE KODECUSTSUPP LIKE :kode
      ', ['kode' => $kodePattern]);

        if (!empty($listData)) {
            $item = $listData[0];

            return response()->json([
                'status' => 200,
                'message' => 'Data berhasil diambil',
                'data' => [
                    'KODECUSTSUPP' => $item->KODECUSTSUPP,
                    'NAMA' => $item->NAMA,
                    'ALAMAT' => $item->ALAMAT,
                    'KOORDINAT' => $item->KOORDINAT,
                ]

            ]);
        }

        return response()->json([
            'status' => 404,
            'message' => 'Tidak ada data',
        ]);


    }
}
