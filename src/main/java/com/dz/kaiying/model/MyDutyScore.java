package com.dz.kaiying.model;



import javax.persistence.*;

import static javax.persistence.GenerationType.IDENTITY;


@Entity
@Table(name = "ky_my_duty_score", catalog = "dzomsdb")
public class MyDutyScore implements java.io.Serializable {

    @Id
    @GeneratedValue(strategy = IDENTITY)
    @Column(name = "id" )
    private Integer id;

    @Column(name = "inputes" )
    private String inputes;

    @Column(name = "score")
    private int score;

    @Column(name = "person_id")
    private String personId;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getInputes() {
        return inputes;
    }

    public void setInputes(String inputes) {
        this.inputes = inputes;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getPersonId() {
        return personId;
    }

    public void setPersonId(String personId) {
        this.personId = personId;
    }
}