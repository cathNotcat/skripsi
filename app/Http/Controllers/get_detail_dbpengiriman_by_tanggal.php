<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class get_detail_dbpengiriman_by_tanggal extends Controller
{
    public function index()
    {
        return response()->json(['message' => 'API is working']);
    }
    public function getData($tanggal)
    {
        // Run the query to fetch the data
        $listData = DB::connection('SML')->select(
            'SELECT p.NoUrut, p.NoPengiriman, p.NoDO, a.Nama, p.KodeCustSupp, a.Alamat, a.Koordinat, p.Status, p.TanggalKirim, COUNT(s.NoBukti) AS JumlahBarang  
                FROM dbPengiriman p
                JOIN dbSPPDet s ON p.noDO = s.NoBukti
                JOIN DBALAMATCUST a ON p.KodeCustSupp = a.KODECUSTSUPP 
                WHERE CAST(TanggalKirim AS DATE) = :tanggal
                GROUP BY p.NoUrut, p.NoPengiriman, p.noDO, p.kodecustsupp, p.Status, a.nama, a.alamat, a.koordinat, p.TanggalKirim
                ORDER BY p.NoUrut',
            ['tanggal' => $tanggal]
        );

        // If no data is found, return an empty response
        if (!$listData) {
            return response()->json([
                'status' => 200,
                'message' => 'No data found',
                'data' => []
            ], 200);
        }

        // Prepare the final output array, returning each record individually
        $finalOutput = [];
        foreach ($listData as $item) {
            $finalOutput[] = [
                'NoUrut' => $item->NoUrut,
                'NoPengiriman' => $item->NoPengiriman,
                'TanggalKirim' => $item->TanggalKirim,
                'NoDO' => $item->NoDO,
                'Nama' => $item->Nama,
                'KodeCustSupp' => $item->KodeCustSupp,
                'Alamat' => $item->Alamat,
                'Koordinat' => $item->Koordinat,
                'Status' => $item->Status,
                'JumlahBarang' => $item->JumlahBarang,
            ];
        }

        // Return the data as a JSON response
        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $finalOutput
        ]);
    }

}
?>