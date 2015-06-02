classdef boardData
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        board_matrix;
    end
    
    methods
        function [] = inputData2Matrix(y, x)
            obj = boardData;
            M = obj.board_matrix;
            M(y, x) = user;
            obj.board_matrix = M;
        end
        
        function [ out ] = get_board_matrix(n)
            obj = boardData;
            out = obj.board_matrix;
        end
    end
    
end

