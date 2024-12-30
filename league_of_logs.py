import tkinter as tk
from tkinter import ttk, messagebox
from enum import Enum
import math

class Role(Enum):
    """
    An enumeration representing the different roles in a League of Legends game.
    """
    ADC = 0
    SUPPORT = 1
    MIDDLE = 2
    JUNGLE = 3
    TOP = 4

class LeagueOfLogsApp:
    def __init__(self, root):
        self.root = root
        self.root.title("League of Logs")
        
        self.AVERAGE_VISION_SCORE_FOR_SUPPORTS = 1.5
        self.AVERAGE_VISION_SCORE = 0.75
        self.DIFFICULTY_SETTING = 2
        self.DIVIDE_BY_FOR_MINUTES = 10
        self.DIVIDE_BY_FOR_REWARD = 2
        
        # Create main frame
        main_frame = ttk.Frame(root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Create and set up the input fields
        self.setup_input_fields(main_frame)
        
        # Create the generate button
        self.setup_generate_button(main_frame)
        
        # Create the results area
        self.setup_results_area(main_frame)
        
        # Add disclaimer
        self.add_disclaimer(main_frame)

    def setup_input_fields(self, frame):
        # Role dropdown
        ttk.Label(frame, text="Role:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.role_var = tk.StringVar()
        role_combo = ttk.Combobox(frame, textvariable=self.role_var)
        role_combo['values'] = ('ADC', 'SUPPORT', 'MIDDLE', 'JUNGLE', 'TOP')
        role_combo.grid(row=0, column=1, sticky=tk.W, pady=5)
        role_combo.set('ADC')
        
        # MVP checkbox
        self.mvp_var = tk.BooleanVar()
        ttk.Checkbutton(frame, text="MVP (Most kills/assists/objectives)?", 
                       variable=self.mvp_var).grid(row=1, column=0, 
                       columnspan=2, sticky=tk.W, pady=5)
        
        # Numeric input fields
        self.numeric_vars = {}
        fields = [
            ("Kills:", "kills"),
            ("Deaths:", "deaths"),
            ("Assists:", "assists"),
            ("Game duration (minutes):", "game_duration"),
            ("Team total kills:", "team_total_kills"),
            ("CS @ 10 minutes:", "cs"),
            ("Vision score:", "vision_score")
        ]
        
        for i, (label, var_name) in enumerate(fields):
            ttk.Label(frame, text=label).grid(row=i+2, column=0, sticky=tk.W, pady=5)
            var = tk.StringVar(value="0")
            self.numeric_vars[var_name] = var
            ttk.Entry(frame, textvariable=var, width=10).grid(row=i+2, column=1, 
                                                             sticky=tk.W, pady=5)

    def setup_generate_button(self, frame):
        ttk.Button(frame, text="Generate Workout", 
                  command=self.generate_workout).grid(row=9, column=0, 
                  columnspan=2, pady=20)

    def setup_results_area(self, frame):
        # Create text widget for results
        self.results_text = tk.Text(frame, height=10, width=50, wrap=tk.WORD)
        self.results_text.grid(row=10, column=0, columnspan=2, pady=10)
        
        # Add scrollbar
        scrollbar = ttk.Scrollbar(frame, orient=tk.VERTICAL, 
                                command=self.results_text.yview)
        scrollbar.grid(row=10, column=2, sticky=(tk.N, tk.S))
        self.results_text['yscrollcommand'] = scrollbar.set

    def add_disclaimer(self, frame):
        disclaimer = ("League of Logs is not endorsed by Riot Games and does not "
                     "reflect the views or opinions of Riot Games or anyone "
                     "officially involved in producing or managing Riot Games "
                     "properties. Riot Games and all associated properties are "
                     "trademarks or registered trademarks of Riot Games, Inc")
        disclaimer_label = ttk.Label(frame, text=disclaimer, wraplength=400)
        disclaimer_label.grid(row=11, column=0, columnspan=2, pady=20)

    def generate_workout(self):
        try:
            # Gather all numeric inputs
            stats = {name: int(var.get()) 
                    for name, var in self.numeric_vars.items()}
            
            # Get role and MVP status
            role = Role[self.role_var.get().upper()]
            mvp = self.mvp_var.get()
            
            # Generate workouts
            workouts = self.generate_workouts(**stats, mvp=mvp, role=role)
            
            # Display results
            self.results_text.delete(1.0, tk.END)
            self.results_text.insert(tk.END, "Who's gonna carry the logs?\n\n")
            for workout in workouts:
                self.results_text.insert(tk.END, f"• {workout}\n")
                
        except ValueError as e:
            messagebox.showerror("Error", "Please enter valid numeric values for all fields.")
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {str(e)}")

    def generate_workouts(self, kills, deaths, assists, game_duration, 
                         team_total_kills, cs, vision_score, mvp, role):
        """
        The same workout generation logic from your original script
        """
        workouts = []

        # PUSH-UPS BASED ON KILLS:
        if role in (Role.ADC, Role.MIDDLE, Role.TOP):
            if not mvp:
                workouts.append(f"You didn't carry, {kills * self.DIFFICULTY_SETTING + deaths} push-ups")
            else:
                workouts.append(f"You carried, only {kills + deaths} push-ups")
        elif role in (Role.SUPPORT, Role.JUNGLE):
            if not mvp:
                workouts.append(f"You didn't carry, {assists * self.DIFFICULTY_SETTING + deaths} push-ups")
            else:
                workouts.append(f"You carried, only {assists} push-ups")

        # SQUATS BASED ON KDA:
        kda = (kills + assists) / max(deaths, 1)  # Avoid division by zero

        if kda > 1:
            workouts.append(f"You didn't feed, only {kills + assists} squats")
        else:
            workouts.append(f"You fed, {kills * deaths + assists} squats")

        # PLANK BASED ON VISION SCORE:
        average_vision_score = (self.AVERAGE_VISION_SCORE_FOR_SUPPORTS 
                              if role == Role.SUPPORT 
                              else self.AVERAGE_VISION_SCORE) * game_duration
        if vision_score < average_vision_score:
            workouts.append(f"Your vision score sucked! {math.ceil(game_duration / self.DIVIDE_BY_FOR_MINUTES)} minute plank")
        else:
            workouts.append(f"Your vision score was great! Only a {math.ceil(game_duration / game_duration)} minute plank")

        # LUNGES BASED ON KILL PARTICIPATION
        kill_participation = ((kills + assists) / max(team_total_kills, 1)) * 100
        if kill_participation < 50:
            workouts.append(f"Your kill participation was ass! {math.ceil(kill_participation * self.DIFFICULTY_SETTING)} lunges")
        else:
            workouts.append(f"Your kill participation was good! {math.ceil(kill_participation / self.DIVIDE_BY_FOR_REWARD)} lunges")

        # KNEE-UPS FOR CS @ 10 MINUTES
        if role != Role.SUPPORT:
            if cs < 50:
                workouts.append(f"Your CS was dogshit! {cs * self.DIFFICULTY_SETTING} knee-ups")
            else:
                workouts.append(f"Your CS was at the bare minimum to avoid my wrath! {math.ceil(cs / self.DIVIDE_BY_FOR_REWARD)} knee-ups")
        else:
            workouts.append(f"This is punishment for every stolen minion and kill! {cs} knee-ups")

        # JUMPING JACKS FOR GAME TIME
        if game_duration < 16:
            workouts.append(f"You surrendered, didn't you? {game_duration * self.DIFFICULTY_SETTING} jumping jacks")
        else:
            if game_duration > 30:
                workouts.append(f"You stalled for too long! {game_duration} jumping jacks")
            else:
                workouts.append(f"You didn't make the enemy surrender! {game_duration + kills} jumping jacks")

        return workouts

def main():
    root = tk.Tk()
    app = LeagueOfLogsApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()