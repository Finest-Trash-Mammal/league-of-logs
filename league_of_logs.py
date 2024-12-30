import tkinter as tk
from tkinter import ttk, messagebox, PhotoImage
from tkinter.font import Font
from enum import Enum
import math
import re
import os
from typing import Dict, Any

class Role(Enum):
    """
    An enumeration representing the different roles in a League of Legends game.
    """
    ADC = 0
    SUPPORT = 1
    MIDDLE = 2
    JUNGLE = 3
    TOP = 4

class ToolTip:
    """
    Creates a tooltip for a given widget when the mouse hovers over it.
    """
    def __init__(self, widget, text):
        self.widget = widget
        self.text = text
        self.tooltip = None
        self.widget.bind("<Enter>", self.show_tooltip)
        self.widget.bind("<Leave>", self.hide_tooltip)

    def show_tooltip(self, event=None):
        x, y, _, _ = self.widget.bbox("insert")
        x += self.widget.winfo_rootx() + 25
        y += self.widget.winfo_rooty() + 20

        # Creates a toplevel window
        self.tooltip = tk.Toplevel(self.widget)
        self.tooltip.wm_overrideredirect(True)
        self.tooltip.wm_geometry(f"+{x}+{y}")

        label = ttk.Label(self.tooltip, text=self.text, justify=tk.LEFT,
                         background="#ffffe0", relief="solid", borderwidth=1)
        label.pack()

    def hide_tooltip(self, event=None):
        if self.tooltip:
            self.tooltip.destroy()
            self.tooltip = None

class LeagueOfLogsApp:
    def __init__(self, root):
        self.root = root
        self.root.title("League of Logs")
        
        # Set up custom styles
        self.setup_styles()
        
        # Constants
        self.AVERAGE_VISION_SCORE_FOR_SUPPORTS = 1.5
        self.AVERAGE_VISION_SCORE = 0.75
        self.DIFFICULTY_SETTING = 2
        self.DIVIDE_BY_FOR_MINUTES = 10
        self.DIVIDE_BY_FOR_REWARD = 2
        
        # Create main frame with padding and configure grid
        main_frame = ttk.Frame(root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid columns and rows to expand properly
        root.columnconfigure(0, weight=1)
        root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        
        # TODO: Implement the set_background_image method
        # Set background image
        # self.set_background_image(main_frame)

        # Add title
        self.add_title(main_frame)
        
        # Create and set up the input fields
        self.setup_input_fields(main_frame)
        
        # Create the buttons
        self.setup_buttons(main_frame)
        
        # Create the results area
        self.setup_results_area(main_frame)
        
        # Add disclaimer
        self.add_disclaimer(main_frame)

    def setup_styles(self):
        """Set up custom styles for the application"""
        style = ttk.Style()
        
        # Configure main style
        style.configure('TLabel', padding=5)
        style.configure('TEntry', padding=5)
        style.configure('TButton', padding=10)
        
        # Custom style for the title
        style.configure('Title.TLabel', font=('Helvetica', 16, 'bold'))
        
        # Custom style for the generate button
        style.configure('Generate.TButton', font=('Helvetica', 10, 'bold'))
        
        # Custom style for the reset button
        style.configure('Reset.TButton', font=('Helvetica', 10))

    # TODO: Implement the set_background_image method
    # def set_background_image(self, frame):
    #     """Set the background image for the application."""
    #     image_path = os.path.join(os.path.dirname(__file__), "resources", "img", "Corki_2.jpg")
    #     try:
    #         self.background_image = PhotoImage(file=image_path)
    #         background_label = tk.Label(frame, image=self.background_image)
    #         background_label.place(relwidth=1, relheight=1)
    #     except tk.TclError as e:
    #         messagebox.showerror("Error", f"Unable to load background image: {e}")

    def add_title(self, frame):
        """Add a title to the application"""
        title_label = ttk.Label(frame, text="League of Logs Workout Generator", 
                               style='Title.TLabel')
        title_label.grid(row=0, column=0, columnspan=2, pady=20)

    def setup_input_fields(self, frame):
        """Set up all input fields with validation and tooltips"""
        # Role dropdown
        ttk.Label(frame, text="Role:").grid(row=1, column=0, sticky=tk.W)
        self.role_var = tk.StringVar()
        role_combo = ttk.Combobox(frame, textvariable=self.role_var, state='readonly')
        role_combo['values'] = ('ADC', 'SUPPORT', 'MIDDLE', 'JUNGLE', 'TOP')
        role_combo.grid(row=1, column=1, sticky=(tk.W, tk.E), padx=5)
        role_combo.set('ADC')
        ToolTip(role_combo, "Select your lane position from the game")
        
        # MVP checkbox
        self.mvp_var = tk.BooleanVar()
        mvp_check = ttk.Checkbutton(frame, text="MVP (Most kills/assists/objectives)?", 
                                   variable=self.mvp_var)
        mvp_check.grid(row=2, column=0, columnspan=2, sticky=tk.W, pady=5)
        ToolTip(mvp_check, "Check this if you had the highest impact in the game")
        
        # Numeric input fields with validation and tooltips
        self.numeric_vars = {}
        fields = [
            ("Kills:", "kills", "Number of enemy champions killed"),
            ("Deaths:", "deaths", "Number of times your champion died"),
            ("Assists:", "assists", "Number of kills you assisted with"),
            ("Game duration (minutes):", "game_duration", "How long the game lasted in minutes"),
            ("Team total kills:", "team_total_kills", "Total kills achieved by your team"),
            ("CS @ 10 minutes:", "cs", "Creep Score (minions killed) at 10 minutes"),
            ("Vision score:", "vision_score", "Your final vision score from the game")
        ]
        
        # Validation command
        vcmd = (self.root.register(self.validate_numeric_input), '%P')
        
        for i, (label, var_name, tooltip) in enumerate(fields):
            ttk.Label(frame, text=label).grid(row=i+3, column=0, sticky=tk.W)
            var = tk.StringVar(value="0")
            self.numeric_vars[var_name] = var
            entry = ttk.Entry(frame, textvariable=var, width=15, 
                            validate='key', validatecommand=vcmd)
            entry.grid(row=i+3, column=1, sticky=(tk.W, tk.E), padx=5, pady=2)
            ToolTip(entry, tooltip)

    def setup_buttons(self, frame):
        """Set up the generate and reset buttons"""
        button_frame = ttk.Frame(frame)
        button_frame.grid(row=10, column=0, columnspan=2, pady=20)
        
        # Generate button
        generate_btn = ttk.Button(button_frame, text="Generate Workout", 
                                command=self.generate_workout, style='Generate.TButton')
        generate_btn.pack(side=tk.LEFT, padx=5)
        ToolTip(generate_btn, "Calculate your workout based on game performance")
        
        # Reset button
        reset_btn = ttk.Button(button_frame, text="Reset Fields", 
                              command=self.reset_fields, style='Reset.TButton')
        reset_btn.pack(side=tk.LEFT, padx=5)
        ToolTip(reset_btn, "Clear all fields to their default values")

    def setup_results_area(self, frame):
        """Set up the results text area with scrollbar"""
        # Create text widget for results
        self.results_text = tk.Text(frame, height=10, width=50, wrap=tk.WORD)
        self.results_text.grid(row=11, column=0, columnspan=2, pady=10, sticky=(tk.W, tk.E))
        self.results_text.configure(font=('Helvetica', 10))
        
        # Add scrollbar
        scrollbar = ttk.Scrollbar(frame, orient=tk.VERTICAL, 
                                command=self.results_text.yview)
        scrollbar.grid(row=11, column=2, sticky=(tk.N, tk.S))
        self.results_text['yscrollcommand'] = scrollbar.set

    def validate_numeric_input(self, value):
        """Validate that input is a positive number or empty"""
        if value == "":
            return True
        if re.match(r"^\d*$", value):
            return True
        return False

    def reset_fields(self):
        """Reset all fields to their default values"""
        self.role_var.set('ADC')
        self.mvp_var.set(False)
        for var in self.numeric_vars.values():
            var.set('0')
        self.results_text.delete(1.0, tk.END)
        
    def validate_all_inputs(self) -> tuple[bool, Dict[str, Any]]:
        """Validate all inputs before generating workout"""
        try:
            stats = {}
            for name, var in self.numeric_vars.items():
                value = int(var.get())
                if value < 0:
                    raise ValueError(f"{name.replace('_', ' ').title()} cannot be negative")
                stats[name] = value
            
            if stats['deaths'] == 0 and (stats['kills'] > 0 or stats['assists'] > 0):
                stats['deaths'] = 1  # Prevent division by zero while maintaining perfect KDA
                
            if stats['team_total_kills'] == 0:
                stats['team_total_kills'] = 1  # Prevent division by zero
                
            return True, stats
        except ValueError as e:
            messagebox.showerror("Invalid Input", str(e))
            return False, {}

    def generate_workout(self):
        """Generate and display the workout based on validated inputs"""
        valid, stats = self.validate_all_inputs()
        if not valid:
            return
            
        try:
            role = Role[self.role_var.get().upper()]
            mvp = self.mvp_var.get()
            
            workouts = generate_workouts(**stats, mvp=mvp, role=role)
            
            self.results_text.delete(1.0, tk.END)
            self.results_text.insert(tk.END, "🏋️ Who's gonna carry the logs? 🏋️\n\n")
            for workout in workouts:
                self.results_text.insert(tk.END, f"💪 {workout}\n")
                
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {str(e)}")

    def add_disclaimer(self, frame):
        """Add the disclaimer text at the bottom"""
        disclaimer = ("League of Logs is not endorsed by Riot Games and does not "
                     "reflect the views or opinions of Riot Games or anyone "
                     "officially involved in producing or managing Riot Games "
                     "properties. Riot Games and all associated properties are "
                     "trademarks or registered trademarks of Riot Games, Inc")
        disclaimer_label = ttk.Label(frame, text=disclaimer, wraplength=400)
        disclaimer_label.grid(row=12, column=0, columnspan=2, pady=20)

def generate_workouts(kills, deaths, assists, game_duration, team_total_kills, cs, vision_score, mvp, role):
    """
    Generates a list of workout tasks based on the performance metrics of a League of Legends game.
    Returns: A list of strings, each representing a workout task based on the player's performance.
    """
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
    root = tk.Tk()
    root.title("League of Logs")
    
    # Set minimum window size
    root.minsize(500, 700)
    
    # Set window icon (if you have one)
    # root.iconbitmap('path_to_your_icon.ico')
    
    app = LeagueOfLogsApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()