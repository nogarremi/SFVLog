from kivy.app import App
from kivy.config import Config
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.spinner import Spinner
from kivy.uix.textinput import TextInput
from kivy.uix.gridlayout import GridLayout
from info import sql_host,sql_port,sql_user,sql_pw,sql_db, path
import pymysql.cursors

def init_conn():
    return pymysql.connect( host=sql_host,port=sql_port,user=sql_user,password=sql_pw,db=sql_db,charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor)

Config.set('graphics', 'height', '800')
Config.set('graphics', 'width', '600')
Config.set('graphics', 'minimum_height', '200')
Config.set('graphics', 'mimimum_width', '300')
Config.write()

char_list=[]
rank_list=[]
conn = init_conn()
try:
    with conn.cursor() as cursor:
        sql = 'SELECT char_name FROM characters'
        cursor.execute(sql)
        for r in cursor:
            char_list.append(r['char_name'])

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
        self.label_update(ranked_wins = (self.rank_wins, ('1','2')), ranked_losses = (self.rank_losses, ('1','1')), casual_wins = (self.cas_wins, ('2','2')), casual_losses = (self.cas_losses, ('2','1')), b_l_wins = (self.bl_wins, ('3','2')), b_l_losses = (self.bl_losses, ('3','1')))

        self.add_widget(self.rank_wins)
        self.add_widget(self.rank_losses)
        self.add_widget(self.cas_wins)
        self.add_widget(self.cas_losses)

        self.add_widget(self.bl_wins)
        self.add_widget(self.bl_losses)

    def writeout(self,instance,**kwargs):
        conn = init_conn()
        try:
            with conn.cursor() as cursor:
                opp_list = {}
                sql = 'SELECT opponents.opp_name, ranks.rank_name FROM opponents JOIN ranks ON opponents.opp_rank_id = ranks.rank_id'
                cursor.execute(sql)
                for r in cursor:
                    opp_list[r['opp_name'].lower()] = r['rank_name']
                
                if self.opp_name.text.lower() not in opp_list:
                    sql = 'INSERT INTO opponents (opp_name, opp_rank_id) VALUES (%s, (SELECT rank_id FROM ranks WHERE rank_name = %s))'
                    cursor.execute(sql, (self.opp_name.text, self.opp_rank.text))
                elif self.opp_rank.text not in opp_list[self.opp_name.text.lower()]:
                    sql = 'UPDATE opponents SET opp_rank_id = (SELECT rank_id FROM ranks WHERE rank_name = %s) WHERE opp_name = %s'
                    cursor.execute(sql, (self.opp_rank.text, self.opp_name.text))

                sql = 'INSERT INTO matches (season, match_type, my_char_id, opp_id, opp_char_id, result) VALUES (%s, %s, (SELECT char_id FROM characters WHERE char_name = %s), (SELECT opp_id FROM opponents WHERE opp_name = %s), (SELECT char_id FROM characters WHERE char_name = %s), %s)'
                cursor.execute(sql, (int(self.season.text), 1 if self.match_type.text.lower() == 'ranked' else 2 if self.match_type.text.lower() == 'casual' else 3, self.my_char.text, self.opp_name.text, self.opp_char.text, 2 if self.result.text.lower() in 'win' else 1))

                conn.commit()
        finally:
            conn.close()

        self.label_update(ranked_wins = (self.rank_wins, ('1','2')), ranked_losses = (self.rank_losses, ('1','1')), casual_wins = (self.cas_wins, ('2','2')), casual_losses = (self.cas_losses, ('2','1')), b_l_wins = (self.bl_wins, ('3','2')), b_l_losses = (self.bl_losses, ('3','1')))

    def label_update(self,**kwargs):
        conn = init_conn()
        try:
            with conn.cursor() as cursor:
                sql = 'SELECT COUNT(*) FROM matches WHERE match_type = %s AND result = %s'
                for k, v in kwargs.items():
                    cursor.execute(sql, v[1])
                    for row in cursor:
                        v[0].text = str(k).replace('_', ' ').title() + ': ' + str(row['COUNT(*)'])
                        if 'ranked_wins' in str(k):
                            with open(path + 'wins.txt','w') as win:
                                win.write(v[0].text[13:])
                        elif 'ranked_losses' in str(k):
                            with open(path + 'losses.txt','w') as loss:
                                loss.write(v[0].text[15:])
        finally:
            conn.close()

class SFVApp(App):
    def build(self):
        self.icon = 'icon.png'
        self.title = 'SFVLog'
        return SFVLog()

if __name__ == '__main__':
    SFVApp().run()
