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

        $formattedData = [];

        foreach ($listData as $item) {
            $formattedData[] = [
                'KODECUSTSUPP' => $item->KODECUSTSUPP,
                'NAMA' => $item->NAMA,
                'ALAMAT' => $item->ALAMAT,
                'KOORDINAT' => $item->KOORDINAT,
            ];
        }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $formattedData
        ]);


    }
}
