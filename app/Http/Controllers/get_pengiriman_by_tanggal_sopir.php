<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class get_pengiriman_by_tanggal_sopir extends Controller
{
    public function getData($tanggal, $sopir)
    {
        $listData = DB::connection('SML')->select(
            'SELECT p.NoUrut, p.NoPengiriman, p.NoDO, p.KodeSopir, a.Nama, p.KodeCustSupp, a.Alamat, a.Koordinat, p.Status, p.TanggalKirim, COUNT(s.NoBukti) AS JumlahBarang  
                FROM dbPengiriman p
                JOIN dbSPPDet s ON p.noDO = s.NoBukti
                JOIN DBALAMATCUST a ON p.KodeCustSupp = a.KODECUSTSUPP 
                WHERE CAST(TanggalKirim AS DATE) = :tanggal 
                AND p.KodeSopir = :sopir
                GROUP BY p.NoUrut, p.NoPengiriman, p.noDO, p.KodeSopir, p.kodecustsupp, p.Status, a.nama, a.alamat, a.koordinat, p.TanggalKirim
                ORDER BY p.NoUrut',
            ['tanggal' => $tanggal, 'sopir' => $sopir]
        );

        if (!$listData) {
            return response()->json([
                'status' => 200,
                'message' => 'Tidak ada pesanan',
                'data' => []
            ], 200);
        }

        $finalOutput = [];
        foreach ($listData as $item) {
            $finalOutput[] = [
                'NoUrut' => $item->NoUrut,
                'NoPengiriman' => $item->NoPengiriman,
                'TanggalKirim' => $item->TanggalKirim,
                'KodeSopir' => $item->KodeSopir,
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