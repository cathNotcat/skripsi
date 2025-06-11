<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;

class get_all_sopir extends Controller
{
    public function getData()
    {
        $data = DB::connection('SML')->select(
            "SELECT Nama FROM dbUser WHERE Role = 'S'"
        );

        if (!$data) {
            return response()->json([
                'status' => 404,
                'message' => 'Tidak ada data',
            ], 404);
        }

        $listNamaSopir = [];

        $listNamaSopir = array_map(function ($item) {
            return $item->Nama;
        }, $data);


        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $listNamaSopir,
        ], 200);
    }
}