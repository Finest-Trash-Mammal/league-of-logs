#!/usr/bin/env python3
from enum import Enum
import math

class Role(Enum):
    ADC = 0
    SUPPORT = 1
    MIDDLE = 2
    JUNGLE = 3
    TOP = 4

def generate_workouts(kills, deaths, assists, game_duration, team_total_kills, cs, vision_score, mvp, role):
    workouts = []

    # PRE-SET VALUES:
    AVERAGE_VISION_SCORE_FOR_SUPPORTS = 1.5
    AVERAGE_VISION_SCORE = 0.75
    DIFFICULTY_SETTING = 2
    DIVIDE_BY_FOR_MINUTES = 10
    DIVIDE_BY_FOR_REWARD = 2

    # PUSH-UPS BASED ON KILLS:
    if role in (Role.ADC, Role.MIDDLE, Role.TOP):
        if not mvp:
            workouts.append(f"You didn't carry, {kills * DIFFICULTY_SETTING + deaths} push-ups")
        else:
            workouts.append(f"You carried, only {kills + deaths} push-ups")
    elif role in (Role.SUPPORT, Role.JUNGLE):
        if not mvp:
            workouts.append(f"You didn't carry, {assists * DIFFICULTY_SETTING + deaths} push-ups")
        else:
            workouts.append(f"You carried, only {assists} push-ups")

    # SQUATS BASED ON KDA:
    kda = (kills + assists) / deaths

    if kda > 1:
        workouts.append(f"You didn't feed, only {kills + assists} squats")
    else:
        workouts.append(f"You fed, {kills * deaths + assists} squats")

    # PLANK BASED ON VISION SCORE:
    average_vision_score = (AVERAGE_VISION_SCORE_FOR_SUPPORTS if role == Role.SUPPORT else AVERAGE_VISION_SCORE) * game_duration
    if vision_score < average_vision_score:
        workouts.append(f"Your vision score sucked! {math.ceil(game_duration / DIVIDE_BY_FOR_MINUTES)} minute plank")
    else:
        workouts.append(f"Your vision score was great! Only a {math.ceil(game_duration / game_duration)} minute plank")

    # LUNGES BASED ON KILL PARTICIPATION
    kill_participation = ((kills + assists) / team_total_kills) * 100
    if kill_participation < 50:
        workouts.append(f"Your kill participation was ass! {math.ceil(kill_participation * DIFFICULTY_SETTING)} lunges")
    else:
        workouts.append(f"Your kill participation was good! {math.ceil(kill_participation / DIVIDE_BY_FOR_REWARD)} lunges")

    # KNEE-UPS FOR CS @ 10 MINUTES
    if role != Role.SUPPORT:
        if cs < 50:
            workouts.append(f"Your CS was dogshit! {cs * DIFFICULTY_SETTING} knee-ups")
        else:
            workouts.append(f"Your CS was at the bare minimum to avoid my wrath! {math.ceil(cs / DIVIDE_BY_FOR_REWARD)} knee-ups")
    else:
        workouts.append(f"This is punishment for every stolen minion and kill! {cs} knee-ups")

    # JUMPING JACKS FOR GAME TIME
    if game_duration < 16:
        workouts.append(f"You surrendered, didn't you? {game_duration * DIFFICULTY_SETTING} jumping jacks")
    else:
        if game_duration > 30:
            workouts.append(f"You stalled for too long! {game_duration} jumping jacks")
        else:
            workouts.append(f"You didn't make the enemy surrender! {game_duration + kills} jumping jacks")

    return workouts

def main():
    # GET ROLE
    role_input = input("Role: ").strip().lower()
    if role_input.lower() not in ["adc", "support", "middle", "jungle", "top"]:
        print("That's not valid!")
        return
    role = Role[role_input.upper()]

    # MVP FLAG
    mvp_input = input("Most kills/assists/objectives? (y/n): ")
    if mvp_input.lower() not in ["y", "yes", "n", "no"]:
        print("That's not valid!")
        return

    # GET OTHER STATS
    try:
        kills = int(input("Kills: "))
        deaths = int(input("Deaths: "))
        assists = int(input("Assists: "))
        game_duration = int(input("Game duration in minutes: "))
        team_total_kills = int(input("Total team kills: "))
        cs = int(input("CS @ 10 minutes: "))
        vision_score = int(input("Vision score: "))
    except ValueError:
        print("Invalid input, please enter numeric values for stats")
        return

    # GENERATE WORKOUT
    stats = {
        "kills": kills,
        "deaths": deaths,
        "assists": assists,
        "game_duration": game_duration,
        "team_total_kills": team_total_kills,
        "cs": cs,
        "vision_score": vision_score,
    }

    workouts = generate_workouts(**stats, mvp=mvp_input, role=role)
    print("\nWho's gonna carry the logs?")
    for workout in workouts:
        print(f"- {workout}")


if __name__ == "__main__":
    main()
    input("\nPress Enter to exit...")
