from kivy.app import App
from kivy.config import Config
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.spinner import Spinner
from kivy.uix.textinput import TextInput
from kivy.uix.gridlayout import GridLayout
from sql_info import sql_host,sql_port,sql_user,sql_pw,sql_db
import pymysql.cursors

Config.set('graphics', 'height', '800')
Config.set('graphics', 'width', '600')
Config.set('graphics', 'minimum_height', '200')
Config.set('graphics', 'mimimum_width', '300')
Config.write()

char_list=[]
opp_list={}
rank_list=[]
conn = pymysql.connect(
    host=sql_host,
    port=sql_port,
    user=sql_user,
    password=sql_pw,
    db=sql_db,
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor)
try:
    with conn.cursor() as cursor:
        sql = 'SELECT char_name FROM characters'
        cursor.execute(sql)
        for r in cursor:
            char_list.append(r['char_name'])

        sql = 'SELECT players.opp_name, ranks.rank_name FROM players JOIN ranks ON players.opp_rank_id = ranks.rank_id'
        cursor.execute(sql)
        for r in cursor:
            opp_list[r['opp_name'].lower()] = r['rank_name']

        sql = 'SELECT rank_name FROM ranks'
        cursor.execute(sql)
        for r in cursor:
            rank_list.append(r['rank_name'])
finally:
    conn.close()

class SFVLog(GridLayout):
    def __init__(self,**kwargs):
        super(SFVLog, self).__init__(**kwargs)

        self.my_char = Spinner(
            text='My Character',
            values=char_list)
        self.opp_char = Spinner(
            text='Opp Character',
            values=char_list)
        self.season = Spinner(
            text='Year',
            values=('2019', '2020'))
        self.result = Spinner(
            text='Result',
            values=('Win', 'Loss'))

        self.add_widget(self.my_char)
        self.add_widget(self.opp_char)
        self.add_widget(self.season)
        self.add_widget(self.result)

        self.match_type = Spinner(
            text='Match Type',
            values=('Ranked', 'Casual', 'Battle Lounge'))
        self.opp_name = TextInput(
            hint_text='Opp Name',
            multiline=False)
        self.opp_rank = Spinner(
            text='Opp Rank',
            values=rank_list)
        self.save = Button(text='Save')
        self.save.bind(on_press=self.writeout)

        self.add_widget(self.match_type)
        self.add_widget(self.opp_name)
        self.add_widget(self.opp_rank)
        self.add_widget(self.save)

        self.rank_wins = Label()
        self.rank_losses = Label()
        self.cas_wins = Label()
        self.cas_losses = Label()
        self.bl_wins = Label()
        self.bl_losses = Label()
        self.label_update(ranked_wins = (self.rank_wins, ('0','1')), ranked_losses = (self.rank_losses, ('0','0')), casual_wins = (self.cas_wins, ('1','1')), casual_losses = (self.cas_losses, ('1','0')), b_l_wins = (self.bl_wins, ('2','1')), b_l_losses = (self.bl_losses, ('2','0')))

        self.add_widget(self.rank_wins)
        self.add_widget(self.rank_losses)
        self.add_widget(self.cas_wins)
        self.add_widget(self.cas_losses)

        self.add_widget(self.bl_wins)
        self.add_widget(self.bl_losses)

    def writeout(self,instance,**kwargs):
        conn = pymysql.connect(
            host=sql_host,
            port=sql_port,
            user=sql_user,
            password=sql_pw,
            db=sql_db,
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor)
        
        try:
            with conn.cursor() as cursor:
                if self.opp_name.text.lower() not in opp_list:
                    sql = 'INSERT INTO players (opp_name, opp_rank_id) VALUES (%s, (SELECT rank_id FROM ranks WHERE rank_name = %s))'
                    cursor.execute(sql, (self.opp_name.text, self.opp_rank.text))
                elif self.opp_rank.text not in opp_list[self.opp_name.text.lower()]:
                    sql = 'UPDATE players SET opp_rank_id = (SELECT rank_id FROM ranks WHERE rank_name = %s) WHERE opp_name = %s'
                    cursor.execute(sql, (self.opp_rank.text, self.opp_name.text))

                sql = 'INSERT INTO matches (season, match_type, my_char_id, opp_id, opp_char_id, result) VALUES (%s, %s, (SELECT char_id FROM characters WHERE char_name = %s), (SELECT opp_id FROM players WHERE opp_name = %s), (SELECT char_id FROM characters WHERE char_name = %s), %s)'
                cursor.execute(sql, (int(self.season.text), 0 if self.match_type.text.lower() == 'ranked' else 1 if self.match_type.text.lower() == 'casual' else 2, self.my_char.text, self.opp_name.text, self.opp_char.text, 1 if self.result.text.lower() in 'win' else 0))

                conn.commit()
        finally:
            conn.close()

        self.label_update(ranked_wins = (self.rank_wins, ('0','1')), ranked_losses = (self.rank_losses, ('0','0')), casual_wins = (self.cas_wins, ('1','1')), casual_losses = (self.cas_losses, ('1','0')), b_l_wins = (self.bl_wins, ('2','1')), b_l_losses = (self.bl_losses, ('2','0')))    

    def label_update(self,**kwargs):

        conn = pymysql.connect(
            host=sql_host,
            port=sql_port,
            user=sql_user,
            password=sql_pw,
            db=sql_db,
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor)
        try:
            with conn.cursor() as cursor:
                sql = 'SELECT COUNT(*) FROM matches WHERE match_type = %s AND result = %s'
                for k, v in kwargs.items():
                    cursor.execute(sql, v[1])
                    for row in cursor:
                        v[0].text = str(k).replace('_', ' ').title() + ': ' + str(row['COUNT(*)'])

                opp_list = {}
                sql = 'SELECT players.opp_name, ranks.rank_name FROM players JOIN ranks ON players.opp_rank_id = ranks.rank_id'
                cursor.execute(sql)
                for r in cursor:
                    opp_list[r['opp_name'].lower()] = r['rank_name']

                rank_list = []
                sql = 'SELECT rank_name FROM ranks'
                cursor.execute(sql)
                for r in cursor:
                    rank_list.append(r['rank_name'])
                    
        finally:
            conn.close()

class SFVApp(App):
    def build(self):
        self.icon = 'icon.png'
        self.title = 'SFVLog'
        return SFVLog()

if __name__ == '__main__':
    SFVApp().run()
