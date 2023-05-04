<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\History;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;

class HistoryController extends Controller
{

    public function show(Request $request) {
        try {
            if($request->date) {
                $histories = History::where(['user_id' => $request->id, 'type' => $request->type, 'date' => $request->date])->get();
            } else {
                $histories = History::where(['user_id' => $request->id, 'type' => $request->type])->get();
            }

            return ResponseFormatter::success([
                'data' => $histories,
            ], 'Get Data Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Get Data Failed', 500);
        }

    }

    public function store(Request $request) 
    {
        try{
            $validatedData = $request->validate([
                "user_id" => ['required'],
                "type" => ['required', 'string'],
                "date" => ['required', 'string'],
                "total" => ['required', 'string'],
                "details" => ['required', 'string'],
            ]);

            $data = History::create($validatedData);
            
            return ResponseFormatter::success([
                'data' => $data
            ], 'Create Data Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Create Data Failed', 500);
        }
    }
}
