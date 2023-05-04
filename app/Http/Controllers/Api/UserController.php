<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function register(Request $request)
    {
        try{
            $validatedData = $request->validate([
                "name" => ['required', 'string', 'max:255'],
                "email" => ['required', 'string', 'email', 'max:255', 'unique:users'],
                "password" => ['required', 'string'],
            ]);

            User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
            ]);

            $user = User::where('email', $request->email)->first();

            // Generate Token
            $tokenResult = $user->createToken('authToken')->plainTextToken;
            
            return ResponseFormatter::success([
                'access_token' => $tokenResult,
                'token_type' => 'Bearer',
                'user' => $user
            ], 'Register Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Authentication Failed', 500);
        }
    }
    
    public function login(Request $request)
    {
        try{
            $validatedData = $request->validate([
                "email" => ['required', 'string', 'email', 'max:255'],
                "password" => ['required'],
            ]);

            $credentials = request(['email', 'password']);
            if(!Auth::attempt($credentials)) {
                return ResponseFormatter::error([
                    'message' => 'Unauthorized',
                ], "Authentication Failed", 500);
            }

            $user = User::where('email', $request->email)->first();

            if(!Hash::check($request->password, $user->password, [])) {
                throw new \Exception('Invalid Credentials');
            }
            // Generate Token
            $tokenResult = $user->createToken('authToken')->plainTextToken;
            
            return ResponseFormatter::success([
                'access_token' => $tokenResult,
                'token_type' => 'Bearer',
                'user' => $user
            ], 'Login Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Authentication Failed', 500);
        }
    }
}
