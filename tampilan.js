import React from "react";
import { Bell, Settings, MessageSquare, Mic, BookOpen, BellRing } from "lucide-react";
import { createActor } from "../../declarations/backend"; // Sesuaikan dengan canister ID 
import { useEffect, useState } from "react";

export default function Home() {
  const [greeting, setGreeting] = useState("Loading...");
  const backend = createActor("Mental_Health_id"); // Ganti dengan canister ID

  useEffect(() => {
    async function fetchGreeting() {
      const response = await backend.getGreeting();
      setGreeting(response);
    }
    fetchGreeting();
  }, []);

  return (
    <div className="w-full min-h-screen bg-gray-100 p-4">
      {/* Header */}
      <div className="flex justify-between items-center bg-blue-500 text-white p-4 rounded-b-3xl relative">
        <div className="flex gap-3">
          <Bell className="w-6 h-6" />
          <Settings className="w-6 h-6" />
        </div>
        <img src="https://via.placeholder.com/40" alt="Profile" className="w-10 h-10 rounded-full border-2 border-white" />
      </div>

      {/* Chat Greeting */}
      <div className="relative bg-orange-300 text-brown-800 p-4 rounded-xl mt-[-20px] mx-4 shadow-md">
        <p className="text-sm">Hallo, Burhan</p>
        <p className="text-lg font-semibold">{greeting}</p>
      </div>

      {/* Explore Menu */}
      <div className="mt-6 px-4">
        <h2 className="font-semibold text-lg">Explore Menu</h2>
        <div className="flex gap-4 mt-3">
          <div className="flex flex-col items-center p-3 w-20 bg-blue-500 text-white rounded-xl shadow-md">
            <MessageSquare className="w-6 h-6" />
            <p className="text-xs mt-1">Chat+</p>
          </div>
          <div className="flex flex-col items-center p-3 w-20 bg-gray-300 text-black rounded-xl shadow-md">
            <Mic className="w-6 h-6" />
            <p className="text-xs mt-1">MCast</p>
          </div>
          <div className="flex flex-col items-center p-3 w-20 bg-gray-300 text-black rounded-xl shadow-md">
            <BookOpen className="w-6 h-6" />
            <p className="text-xs mt-1">Sense</p>
          </div>
          <div className="flex flex-col items-center p-3 w-20 bg-gray-300 text-black rounded-xl shadow-md">
            <BellRing className="w-6 h-6" />
            <p className="text-xs mt-1">Remind</p>
          </div>
        </div>
      </div>

      {/* Story Section */}
      <div className="mt-6 px-4">
        <h2 className="font-semibold text-lg">Story</h2>
        <div className="bg-orange-300 p-6 rounded-xl mt-2 shadow-md">
          <h3 className="font-semibold">Bahagia, why not?</h3>
          <p className="text-sm">Kadang kita terlalu sibuk mencari kebahagiaan sampai lupa bahwa kebahagiaan itu sederhana.</p>
        </div>
      </div>
    </div>
  );
}
